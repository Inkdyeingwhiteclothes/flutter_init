import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hm_shop/viewmodels/home.dart';


class HmSlider extends StatefulWidget {
  final List<BannerItem> banners;
  const HmSlider({super.key, required this.banners});

  @override
  State<HmSlider> createState() => _HmSliderState();
}

class _HmSliderState extends State<HmSlider> {
  //切换需要声明
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  Widget _getSlider(){
    // 返回轮播图插件
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: CarouselSlider( //绑定指示灯
        carouselController: _controller,
        items: List.generate(widget.banners.length, (int index) {
          return SizedBox.expand(
            child: ClipRect(
              child: Image.network(
                widget.banners[index].imgUrl,
                fit: BoxFit.fill,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  );
                },
              ),
            ),
          );
        }),
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          disableCenter: true,
          onPageChanged: (int index, CarouselPageChangedReason reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _getSearch(){
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            "搜索...",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
  //返回指示灯
  Widget _getDots(){
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (int index) {
            return 
            GestureDetector(
              onTap: () {
                _controller.jumpToPage(index);
                setState(() {
                  _currentIndex = index;
                });
              },
              child: AnimatedContainer(
              width: index == _currentIndex ? 40 : 20,
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 4),
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: index == _currentIndex ? Colors.white : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ));
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getSlider(),
        _getSearch(),
        _getDots(),
      ],
    );

    // return Container(
    //   height: 300,
    //   alignment: Alignment.center,
    //   color: Colors.blue,
    //   child: Text("轮播图",style: TextStyle(color: Colors.white,fontSize: 20),),
    // );
  }
}