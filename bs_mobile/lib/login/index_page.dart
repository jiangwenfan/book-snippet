import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:bs_mobile/api_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 登陆首页
class LoginIndexPage extends HookWidget {
  final GoogleSignIn googleSign = GoogleSignIn();

  LoginIndexPage({super.key});

  void _showIOSBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          // title: const Text("标题"),
          // message: const Text("这是一个RiOS风格的Bottom Sheet"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              // isDefaultAction: true,
              child: const Text("通过 手机 登陆"),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                print("通过 google 登陆");
                try {
                  final GoogleSignInAccount? account =
                      await googleSign.signIn();
                  if (account == null) {
                    return;
                  }

                  final GoogleSignInAuthentication authentication =
                      await account.authentication;
                  final String? idToken = authentication.idToken;
                  if (idToken == null) {
                    return;
                  }

                  print("想后端发送idToken.....${idToken}");
                  final response = await ApiData.googleLogin(idToken);
                  // {token: xxxx}
                  final responseData = response as Map<String, dynamic>;
                  print("google登陆成功...${responseData}");

                  loginInit(context, responseData["token"]);
                } catch (e) {
                  print("google登陆错误...${e}");
                }
              },
              // isDestructiveAction: true,
              child: const Text("通过 google 登陆"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
        );
      },
    );
  }

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
              onPressed: () async {
                print("其他登陆方式");
                _showIOSBottomSheet(context);
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
    final isChecked = useState(false);

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
            print("查看服务协议");
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text("<服务协议>"),
        ),
        TextButton(
          onPressed: () {
            print("查看隐私政策");
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text("<隐私政策>"),
        ),
      ],
    );
  }
}

class GoogleSign extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
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
