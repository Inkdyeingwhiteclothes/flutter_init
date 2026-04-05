import 'package:flutter/material.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HmCategory extends StatefulWidget {
  final List<CategoryItem> categories;
  const HmCategory({super.key, required this.categories});

  @override
  State<HmCategory> createState() => _HmCategoryState();
}

class _HmCategoryState extends State<HmCategory> {
  @override
  Widget build(BuildContext context) {
    // 返回一个横向滚动
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 横向滚动
        itemCount: widget.categories.length,
        itemBuilder: (BuildContext contex, int index) {
          final category = widget.categories[index];
          return Container(
            alignment: Alignment.center,
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  category.picture!,
                  width: 40,
                  height: 40,
                ),
                Text(
                  category.name!,
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
            
          );
        },
      ),
    );
  }
}