// 二次封装
import 'package:dio/dio.dart';
import 'package:hm_shop/stores/TokenManager.dart';
import '../constants/index.dart';

class DioRequest {
  final _dio = Dio(); // 创建 Dio 实例
  // 设置基础地址拦截器
  DioRequest() {
    _dio.options..baseUrl = GlobalConstants.BASE_URL
    ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
    ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
    ..receiveTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    _addInterceptors();
  }
  // 添加拦截器
  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        // 在请求发送前添加 token
        String token = tokenManager.getToken();
        if (token.isNotEmpty) {
          request.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(request);
      },
      onResponse: (response, handler) {
        // 在响应返回前处理
        final data = response.data;
        if (data is Map<String, dynamic> && data["code"].toString() == "401") {
          // Token 校验失败，清除本地 token 并可以根据需要处理跳转
          tokenManager.removeToken();
          return handler.reject(DioException(
            requestOptions: response.requestOptions,
            message: "token校验失败",
            response: response,
          ));
        }
        if(response.statusCode! >= 200 && response.statusCode! < 300) {
          // 处理成功响应
          handler.next(response);
          return;
        }
        handler.reject(DioException(requestOptions: response.requestOptions));
      },
      onError: (error, handler) {
        // 在错误发生时处理
        String message = "网络请求失败";
        if (error.type == DioExceptionType.connectionError) {
          message = "连接服务器失败，请检查网络或域名是否有效";
        } else if (error.type == DioExceptionType.receiveTimeout) {
          message = "服务器响应超时";
        }
        print("DioError: $message (${error.message})");
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          message: error.response?.data["msg"]??" ",
        ));
      },
    ));

    
    }

  Future<dynamic> get (String url,{Map<String, dynamic>? params}){
      return _handleResponse(_dio.get(url, queryParameters: params));
    }

  Future<dynamic> post(String url,{Map<String, dynamic>? data}){
      return _handleResponse(_dio.post(url, data: data));
    }

  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async{
      try{
        Response<dynamic> res = await task;
        // debugPrint("DioRequest Response: ${res.data}");
        final data = res.data as Map<String, dynamic>;
        // 兼容处理：code 可能为 String 或 int，且统一转换为字符串比较
        if(data["code"].toString() == GlobalConstants.SUCCESS_CODE.toString()) {
          return data["result"];
        }
        throw DioException(
          requestOptions: RequestOptions(),
          message: data["msg"] ?? "加载失败",
        );
      } catch (e) {
        // debugPrint("DioRequest Error detail: $e");
        rethrow;
      }
}
}

final dioRequest = DioRequest();


// dio请求工具发出请求 返回的数据 Response<dynamic>.date
// 把所有接口的date解放出来 拿到真正的数据 要判断业务状态码是不是等于1