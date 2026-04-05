import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hm_shop/api/user.dart';
import 'package:hm_shop/pages/Home/index.dart';
import 'package:hm_shop/pages/Category/index.dart';
import 'package:hm_shop/pages/Cart/index.dart';
import 'package:hm_shop/pages/Mine/index.dart';
import 'package:hm_shop/stores/TokenManager.dart';
import 'package:hm_shop/stores/UserControl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Map<String, String>> navList = [
    {
      'icon': 'lib/assets/home_inactive.jpg',
      'active_icon': 'lib/assets/home_active.jpg',
      'text': '首页'
    },
    {
      'icon': 'lib/assets/category_inactive.jpg',
      'active_icon': 'lib/assets/category_active.jpg',
      'text': '分类'
    },
    {
      'icon': 'lib/assets/cart_inactive.jpg',
      'active_icon': 'lib/assets/cart_active.jpg',
      'text': '购物车'
    },
    {
      'icon': 'lib/assets/my_inactive.jpg',
      'active_icon': 'lib/assets/my_active.jpg',
      'text': '我的'
    },
  ];

  int _currentIndex = 0;

  final List<Widget> _pages = [
   HomeView(),
   CategoryView(),
   CartView(),
   MineView(),
  ];

  @override
  void initState(){
    // TODO: implement activate
    super.initState();
    _initUser();
  }

  final UserController _userController =Get.put(UserController());
  _initUser()async{
    await tokenManager.init();
    if(tokenManager.getToken().isNotEmpty){
      _userController.updateUserInfo(await getUserInfoAPI()); 
    }
  }


  // 返回底部渲染的四个分类
  List<BottomNavigationBarItem> _getTabBarWidget(){
    return List.generate(navList.length, (int index){
      return BottomNavigationBarItem(
        icon: Image.asset(
          navList[index]["icon"]!,
          width: 30,
          height: 30,
        ),
        activeIcon: Image.asset(
          navList[index]["active_icon"]!,
          width: 30,
          height: 30,
        ),
        label: navList[index]["text"],
      );

    });
  }

  List<Widget> _getChildren(){
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea避开安全区组件
      body: SafeArea(
        // 堆叠索引组件
        child: IndexedStack(
          index: _currentIndex,
          children: _getChildren(),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: (int index){
          // index就是当前索引
          _currentIndex = index;
          setState(() {
            
          });
        },
        currentIndex: _currentIndex,
        items:_getTabBarWidget()
      ),
    );
  }
}