import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserPage extends HookWidget {
  const UserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: Text("user"),
      widget: Column(
        children: [
          Text("user"),
          ElevatedButton(onPressed: () {}, child: Text("清理登陆")),
        ],
      ),
    );
  }
}
