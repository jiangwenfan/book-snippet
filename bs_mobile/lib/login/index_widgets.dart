import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:bs_mobile/login/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/utils.dart';

// 微信登陆widget
class WeChatSign extends HookWidget {
  const WeChatSign({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      loginIcon: Icon(Icons.wechat),
      loginText: "通过 微信 登陆",
      loginFunction: () {
        print("通过 微信 登陆");
      },
    );
  }
}

// 显示app的logo
class AppLogo extends HookWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo2.png',
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ],
    );
  }
}

class ReadmeWidget extends HookWidget {
  final ValueNotifier<bool> isChecked;
  const ReadmeWidget({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: isChecked.value,
          onChanged: (value) {
            isChecked.value = value!;
          },
          visualDensity: VisualDensity.compact, // 减少内边距
        ),
        Text("我已阅读并同意"),
        TextButton(
          onPressed: () {
            //  TODO 跳转到服务协议页面
            print("查看服务协议");
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text("<服务协议>"),
        ),
        TextButton(
          onPressed: () {
            //  TODO 跳转到隐私政策页面
            print("查看隐私政策");
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text("<隐私政策>"),
        ),
      ],
    );
  }
}

// Apple登陆widget
class AppleSign extends HookWidget {
  const AppleSign({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      loginIcon: Icon(Icons.apple),
      loginText: "通过 Apple 登陆",
      loginFunction: () {
        print("通过 Apple 登陆");
      },
    );
  }
}

// google登陆action
class GoogleSignAction extends HookWidget {
  const GoogleSignAction({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () async {
        final status = await handleGoogleSign();
        // final status = await handleGoogleSign();
        if (status) {
          // 1. 获取用户数据
          getUserLastData();
          print("登陆-google成功-获取用户数据");

          // 2. 跳转到首页
          context.go("/snippet");
          print("登陆-google成功-跳转到snippet页面");
        }
        // 确保 widget 仍然挂载（未被销毁）
        // Future.microtask(() {
        //   context.go("/snippet");
        // });

        // 2. 关闭当前页面
        // Navigator.pop(context);
      },
      child: const Text("通过 google 登陆"),
    );
  }
}

// 手机号登录action
class PhoneSignAction extends HookWidget {
  const PhoneSignAction({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () => Navigator.pop(context),
      child: const Text("通过 手机 登陆"),
    );
  }
}

// --- utils---
// 统一的登陆按钮
class LoginButton extends HookWidget {
  final Widget loginIcon;
  final String loginText;
  final VoidCallback loginFunction;
  const LoginButton({
    super.key,
    required this.loginIcon,
    required this.loginText,
    required this.loginFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 65,
      margin: EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        onPressed: loginFunction,
        icon: loginIcon,
        label: Text(loginText, style: TextStyle(fontSize: 20)),
        style: ButtonStyle(iconSize: WidgetStateProperty.all(33)),
      ),
    );
  }
}
