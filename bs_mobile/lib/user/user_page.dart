import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class UserPage extends HookWidget {
  const UserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: Text("user"),
      widget: Column(
        children: [
          Text("user"),
          ElevatedButton(
            onPressed: () {
              // 清理登陆
              SharedPreferenceOp.clearAll();

              // 重新登陆
              GoRouter.of(context).go("/loginIndex");
            },
            child: Text("清理所有数据"),
          ),
        ],
      ),
    );
  }
}
