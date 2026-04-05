import 'package:flutter/material.dart';
import 'package:hm_shop/pages/Main/index.dart';
import 'package:hm_shop/pages/Login/login.dart';

//返回app根级组件
Widget getRootWidget() {
  return MaterialApp(
    //命名路由
    initialRoute: "/", //设置默认路由
    routes: getRootRoutes(),
  );
}
// 返回该App的路由配置
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(),
    "/login": (context) => LoginPage(),
  };
}
