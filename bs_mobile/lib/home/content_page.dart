import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContentPage extends HookWidget {
  const ContentPage({super.key});
  @override
  Widget build(BuildContext context) {
    BasePage(
      title: TitleWidget(title: "书摘"),
      widget: ListView(
        children: [
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
    // TODO 从全局读取数据

    return Scaffold(
      appBar: AppBar(
        title: Text("密码"),
        centerTitle: false,
        // leading: BackButton(),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/category");
            // context.go("/category");
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              print("用户中心");
            },
          ),
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: () {
              print("全选");
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "全部",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          // TODO 2.当没有数据时，禁用掉输入框
          //    Padding(
          //   padding: EdgeInsets.all(16),
          //   child:
          // ),
          SearchWidget(),

          // 3. 显示内容
          ContentWidget(),
        ],
      ),
    );
  }
}

class ContentWidget extends HookWidget {
  const ContentWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return
    // TODO 如果没有数据 就显示加载中
    // CircularProgressIndicator(),
    Expanded(
      child: ListView.builder(
        // TODO 显示内容
        itemCount: 10,
        itemBuilder: (context, index) {
          return Item(
            text:
                "item $index 在这动荡不安的年代，他以非凡的勇气和智慧，带领人民走过了一段艰难而又辉煌的历程。每一个决策背后，都是无数个不眠之夜的深思熟虑；每一步前进，都凝聚着对国家和民族未来的深切期盼",
          );
        },
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
