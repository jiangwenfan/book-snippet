import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

// 用户中心button
class UserCenterButton extends HookWidget {
  const UserCenterButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.people),
      onPressed: () {
        // 进入用户页面
        GoRouter.of(context).go("/user");
      },
    );
  }
}

// 正文内容的标题
class ContentTitle extends HookWidget {
  final String title;
  const ContentTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
