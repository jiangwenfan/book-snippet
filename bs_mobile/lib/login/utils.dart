import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bs_mobile/api_data.dart';
import 'package:bs_mobile/utils.dart';

// 处理google登陆操作
Future<void> handleGoogleSign(BuildContext context) async {
  final GoogleSignIn googleSign = GoogleSignIn();

  try {
    final GoogleSignInAccount? account = await googleSign.signIn();
    if (account == null) {
      return;
    }

    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final String? idToken = authentication.idToken;
    if (idToken == null) {
      return;
    }

    print("向后端发送idToken.....${idToken}");
    final response = await ApiData.googleLogin(idToken);
    // {token: xxxx}
    final responseData = response as Map<String, dynamic>;
    print("google登陆成功...${responseData}");

    loginInit(context, responseData["token"]);
  } catch (e) {
    print("google登陆错误...${e}");
  }
}
