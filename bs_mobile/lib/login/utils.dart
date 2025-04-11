import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bs_mobile/api_data.dart';
import 'package:bs_mobile/common_utils.dart';

// 处理google登陆操作
Future<bool> handleGoogleSign() async {
  final GoogleSignIn googleSign = GoogleSignIn();

  try {
    final GoogleSignInAccount? account = await googleSign.signIn();
    if (account == null) {
      return false;
    }

    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final String? idToken = authentication.idToken;
    if (idToken == null) {
      return false;
    }

    print("登陆-google-idToken长度:${idToken.length}");
    final response = await ApiData.googleLogin(idToken);

    // {token: xxxx}
    final responseData = response as Map<String, dynamic>;
    print("登陆-google-登陆成功,token长度${responseData["token"].length}");

    loginInit(responseData["token"]);
    print("登陆-google-登陆成功,token已保存");

    return true;
  } catch (e) {
    print("登陆-google-登陆失败:${e.toString()}");
    return false;
  }
}
