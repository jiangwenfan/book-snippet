import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:bs_mobile/login/index_widgets.dart';

// 登陆首页
class LoginIndexPage extends HookWidget {
  const LoginIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 是否勾选同意协议
    final isChecked = useState(false);

    return BasePage(
      title: null,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 1. 显示app的logo
          AppLogo(),
          SizedBox(height: 110),

          // 2.1 显示微信登陆按钮
          WeChatSign(),
          // 2.2 显示Apple登陆按钮
          AppleSign(),

          // 3. 显示同意协议的按钮
          ReadmeWidget(isChecked: isChecked),

          // 4. 显示其他登陆按钮
          Container(
            margin: EdgeInsets.only(top: 40),
            child: TextButton(
              onPressed: () {
                if (isChecked.value == false) {
                  showSimpleDialogWidget(
                    context: context,
                    title: "提示",
                    content: "请先同意服务协议和隐私政策",
                  );
                  return;
                }
                // 显示其他登陆方式
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => OtherSignAction(),
                );
              },
              child: Text(
                "其他登陆方式",
                style: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 其他登陆方式的main
class OtherSignAction extends HookWidget {
  const OtherSignAction({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        // 1. google 登陆
        GoogleSignAction(),

        // 2. 手机号登陆
        PhoneSignAction(),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text("取消"),
      ),
    );
  }
}
