import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContentPage extends HookWidget {
  const ContentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: TitleWidget(title: "书摘"),
      widget: ListView(
        children: [
          Item(
            text:
                "在这动荡不安的年代，他以非凡的勇气和智慧，带领人民走过了一段艰难而又辉煌的历程。每一个决策背后，都是无数个不眠之夜的深思熟虑；每一步前进，都凝聚着对国家和民族未来的深切期盼",
          ),
          Item(
            text: "随着飞船缓缓驶入未知星系，浩瀚宇宙的真实面貌逐渐展现在他们眼前。星星不再是遥远而冰冷的光点，而是变成了指引前行的灯塔。",
          ),
          Item(text: "在这个世界上，有一种爱情，是不需要言语的。它是一种默契，一种默契的默契，一种默契的默契的默契。"),
          Item(text: "在这个世界上，有一种爱情，是不需要言语的。"),
          //
          // BottomInfo(count: 154),
          AddItem(),
        ],
      ),
    );
  }
}

//  --- utils ---
class Item extends HookWidget {
  final String text;
  const Item({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
