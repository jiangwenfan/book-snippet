import 'package:bs_mobile/home/content_page.dart';
import 'package:bs_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bs_mobile/utils.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // 保持启动页
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // init 1. 获取token
  final String? token = await TokenOp.readToken();
  print("启动-1.读取token为: ${token?.length} 长度");

  // 2. 如果token不为空，用户已经登陆，则获取用户数据
  if (token != null) {
    getUserLastData();
    print("启动-2.正在异步用户最新数据...");
  }

  // 移除启动页
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '小书摘',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
