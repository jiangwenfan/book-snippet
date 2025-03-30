import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

// 用户中心button
class UserCenterButton extends HookWidget {
  const UserCenterButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person),
      onPressed: () {
        // 进入用户页面
        // print("点击-用户中心");
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
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        title,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }
}

//  --- utils ---
class Item extends HookWidget {
  final String text;
  final List<String> labels;
  const Item({super.key, required this.text, required this.labels});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 0, 14, 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            text,
            style: TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Wrap(
            spacing: 5,
            children:
                labels
                    .map(
                      (e) => Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 123, 255),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "#$e",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
