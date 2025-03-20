import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  const SearchWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
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
}
