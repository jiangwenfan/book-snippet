import 'package:bs_mobile/home/content_page.dart';
import 'package:flutter/material.dart';
import 'package:bs_mobile/login/index_page.dart';
import 'package:bs_mobile/home/category_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bs_mobile/utils.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // 保持启动页
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // init 1. 获取token
  final String? token = await TokenOp.readToken();
  print("启动: token: $token");

  // 移除启动页
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return LoginIndexPage();
    // return CategoryPage();
    return ContentPage();
  }
}
