import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/user.dart';

Future<UserInfo> loginAPI(Map<String, dynamic> data) async {
  // TODO: 实现登录逻辑
  return UserInfo.fromJSON(
    await dioRequest.post(HttpConstants.LOGIN, data: data),
  );
}

Future <UserInfo> getUserInfoAPI()async{
  return UserInfo.fromJSON(
    await dioRequest.get(HttpConstants.USER_PROFILE),
  );
}