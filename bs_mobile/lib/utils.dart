import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 全局基础页面
class BasePage extends HookWidget {
  final Widget widget;
  final Widget? title;
  const BasePage({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // ios风格，关闭居中标题
        toolbarHeight: 130,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: title,
      ),

      body: widget,
    );
  }
}

// 搜索widget
class SearchWidget extends HookWidget {
  final bool readOnly;
  const SearchWidget({super.key, this.readOnly = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      child: TextField(
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: "搜索书摘",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

// 全局标题widget
class TitleWidget extends HookWidget {
  final String title;
  const TitleWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }
}

// home的底部bottom
class BottomInfoBase extends HookWidget {
  final Widget? widget1;
  final Widget? widget2;
  const BottomInfoBase({
    super.key,
    required this.widget1,
    required this.widget2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        mainAxisAlignment:
            widget1 == null
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceAround,
        children: [
          // widget1!,
          // widget2!,
          if (widget1 != null) widget1!,
          if (widget2 != null) widget2!,
          IconButton(
            onPressed: () {
              print("添加");
            },
            icon: Icon(Icons.add, size: 45),
          ),
        ],
      ),
    );
  }
}

class BottomInfo extends HookWidget {
  final int count;
  const BottomInfo({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return BottomInfoBase(
      widget1: Icon(Icons.arrow_circle_up, size: 45),
      widget2: Text("$count个项目", style: TextStyle(fontSize: 20)),
    );
  }
}

// bottom 添加书摘widget
class AddItem extends HookWidget {
  const AddItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(color: Colors.grey),
      child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: 200,
          //   margin: EdgeInsets.all(10),
          //   padding: EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     color: Colors.yellow,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [],
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("书摘句子"),
              Container(
                width: double.infinity,
                height: 200,
                margin: EdgeInsets.all(10),
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "请输入书摘句子",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 将token存储起来
class TokenOp {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> writeToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  static Future<String?> readToken() async {
    return await storage.read(key: "token");
  }

  // 清空本地所有数据
  static Future<void> clearAll() async {
    await storage.deleteAll();
  }
}

class SharedPreferenceOp {
  // 清空本地数据
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // ---------------写入数据--------------------
  static Future<void> _writeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // 写入所有分类数据
  static Future<void> writeAllCategory(Map<String, dynamic> data) async {
    final key = "allCategory";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 写入所有标签数据
  static Future<void> writeAllLabel(Map<String, dynamic> data) async {
    final key = "allLabel";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 写入本地全部书摘数据
  static Future<void> writePartContent(Map<String, dynamic> data) async {
    final key = "partContent";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 根据分类写入书摘数据
  static Future<void> writeContentByCategory(
    String category,
    Map<String, dynamic> data,
  ) async {
    final key = "contentByCategory_$category";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // ---------------读取数据--------------------
  static Future<String?> _readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(key);
    return res;
  }

  // 读取所有分类数据
  static Future<Map<String, dynamic>?> readAllCategory() async {
    final key = "allCategory";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 读取所有标签数据
  static Future<Map<String, dynamic>?> readAllLabel() async {
    final key = "allLabel";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 读取本地全部书摘数据
  static Future<Map<String, dynamic>?> readPartContent() async {
    final key = "partContent";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 根据分类读取书摘数据
  static Future<Map<String, dynamic>?> readContentByCategory(
    String category,
  ) async {
    final key = "contentByCategory_$category";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }
}

// 获取用户最新数据
Future<void> getUserLastData() async {
  // 2.1 获取该用户所有分类
  final res1 = await ApiData.getCategory();
  // 写入全局变量,暂时写到shared_preferences中
  await SharedPreferenceOp.writeAllCategory(res1);

  // 2.2 获取该用户所有标签
  final res2 = await ApiData.getLabel();
  await SharedPreferenceOp.writeAllLabel(res2);

  // 2.3 获取该用户第一页的全部书摘
  final res3 = await ApiData.getAllContent();
  await SharedPreferenceOp.writePartContent(res3);
}

// 登陆成之后初始化
void loginInit(context, String token) async {
  // 将token存储起来
  await TokenOp.writeToken(token);
  // 2. 发送请求，获取用户数据
  getUserLastData();
  // 1. 跳转到首页
  context.go("/content");
}
