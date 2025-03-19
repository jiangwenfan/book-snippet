import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';

// 登陆首页
class LoginIndexPage extends HookWidget {
  const LoginIndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: null,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ],
          ),
          SizedBox(height: 110),
          LoginButton(
            loginIcon: Icon(Icons.circle),
            loginText: "通过 微信 登陆",
            loginFunction: () {
              print("通过 微信 登陆");
            },
          ),
          LoginButton(
            loginIcon: Icon(Icons.apple),
            loginText: "通过 Apple 登陆",
            loginFunction: () {
              print("通过 Apple 登陆");
            },
          ),
          ReadmeWidget(),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: TextButton(
              onPressed: () {
                print("其他登陆方式");
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

class ReadmeWidget extends HookWidget {
  const ReadmeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: "ok",
          groupValue: "1",
          onChanged: (value) {
            print("ok");
          },
        ),
        Text("我已阅读并同意"),
        TextButton(
          onPressed: () {
            print("查看服务协议");
          },
          child: Text("<服务协议>"),
        ),
        TextButton(
          onPressed: () {
            print("查看隐私政策");
          },
          child: Text("<隐私政策>"),
        ),
      ],
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
