import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/Home/HmCategory.dart';
import 'package:hm_shop/components/Home/HmHot.dart';
import 'package:hm_shop/components/Home/HmSlider.dart';
import 'package:hm_shop/components/Home/HmSuggestion.dart';
import 'package:hm_shop/components/Home/HmMoreList.dart';
import 'package:hm_shop/utils/Toastutils.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CategoryItem> _categories = [];
  List<BannerItem> _banners = [];
  // 或缺滚动容器的内容
  List<Widget> _getScrollChildren() { // 函数表示列表
    return [// 先用sliver家族包裹
      // 包裹普通widget的sliver家族的组件
      SliverToBoxAdapter(child: HmSlider(banners: _banners),),
      // 放置分类组件
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      // SliverGrid SliverList只能纵向排列
      //ListView
      SliverToBoxAdapter(child: HmCategory(categories: _categories),),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      SliverToBoxAdapter(child: HmSuggestion(specialRecommendResult: _specialRecommendResult)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      SliverToBoxAdapter(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: HmHot(result: _inVogueResult, type:"hot")),
            SizedBox(width: 10),
            Expanded(child: HmHot(result:_oneStopResult, type:"step")),

          ],
        )
      ),
    ),
    SliverToBoxAdapter(child: SizedBox(height: 10)),
    HmMoreList(recommendList: _recommendList), // 无限滚动列表

  ];
  }

  Future<void> _getBannderList() async {
    try {
      _banners = await getBannerListAPI();
      setState(() {});
    } catch (e) {
      debugPrint("获取轮播图失败: $e");
    }
  }

  Future<void> _getCategoryList() async {
    try {
      _categories = await getCategoryListAPI();
      setState(() {});
    } catch (e) {
      debugPrint("获取分类列表失败: $e");
    }
  }

  SpecialRecommendResult _specialRecommendResult = SpecialRecommendResult(id: '', title: '', subTypes: []);

  Future<void> _getSpecialList() async {
    try {
      _specialRecommendResult = await getProductListAPI();
      setState(() {});
    } catch (e) {
      debugPrint("获取特色推荐失败: $e");
    }
  }


 SpecialRecommendResult _inVogueResult = SpecialRecommendResult(id: '', title: '', subTypes: []);
  

  Future<void> _gerInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
    setState(() {});
  }

 SpecialRecommendResult _oneStopResult = SpecialRecommendResult(id: '', title: '', subTypes: []);

  Future<void> _getHotList() async {
    _oneStopResult = await getOneStopListAPI();
    setState(() {});
  }

  // 推荐列表
  List<GoodDetailItem> _recommendList = [];

  // 获取推荐列表
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore =true;
  double _paddingTop=0;
  Future<void> _getRecommendList() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    _isLoading = true;
    int requesLimit = _page*10;
    _recommendList = await getRecommendListAPI({"limit": requesLimit});
    _isLoading = false;
    setState(() {});
    if(_recommendList.length<requesLimit)
    {
      _hasMore = false;
      return;
    }
    _page++;
  }
  // 监听滚动
  void _registerEvent() {
    _controller.addListener(() {
      if (_controller.position.pixels >=
          (_controller.position.maxScrollExtent - 50)) {
        _getRecommendList();
      }
    });
  }

  Future<void> _onRefresh()async{
    _page = 1;
    _isLoading=false;
    _hasMore = true;
    await _getBannderList();
    await _getCategoryList();
    await _getSpecialList();
    await _gerInVogueList();
    await _getHotList();
    await _getRecommendList();

    ToastUtils.showToast(context, "刷新成功");
    _paddingTop =0;
    setState(() {});
  }

  

  @override
  void initState() {
    super.initState();
    _registerEvent();
    Future.microtask((){
      _paddingTop =100;
      setState(() {
        
      });
      _key.currentState?.show();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  final ScrollController _controller = ScrollController();
  final GlobalKey<RefreshIndicatorState> _key=GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _key,
      onRefresh: _onRefresh, 
      child: AnimatedContainer(// slivers家族内容
        padding: EdgeInsets.only(top: _paddingTop),
        duration: Duration(milliseconds: 300),
        child: CustomScrollView(
          slivers: _getScrollChildren(),
          controller: _controller,
        ),
      )
    );
    
  }
}