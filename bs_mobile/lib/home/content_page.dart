import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContentPage extends HookWidget {
  const ContentPage({super.key});

  Future<void> getLocalData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> content,
  ) async {
    final res = await SharedPreferenceOp.readPartContent();

    // 更新到当前状态
    isLoading.value = false;
    if (res != null) {
      content.value = res["results"];
    }
    print("从 local 读取[部分content]数据: $res");
  }

  Future<void> getRemoteData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> content,
  ) async {
    await getUserLastData();
    print("从 remote 读取[所有数据]保存到local");

    await getLocalData(isLoading, content);
  }

  @override
  Widget build(BuildContext context) {
    // BottomInfo(count: 154),
    // AddItem(),

    final isLoading = useState(false);
    final contentData = useState([]);

    useEffect(() {
      // 当页面加载时，
      // 1.1 从本地/全局读取数据，显示
      getLocalData(isLoading, contentData);

      // 1.2 获取最新数据
      getRemoteData(isLoading, contentData);
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text("书摘"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            // 进入分类页面
            GoRouter.of(context).go("/category");
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              // 进入用户页面
              GoRouter.of(context).go("/user");
            },
          ),
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: () {
              print("点击-全选");
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "全部",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          // 当正在加载时，禁止输入框
          isLoading.value ? SearchWidget(readOnly: true) : SearchWidget(),

          // 3. 正在加载时，显示加载中
          isLoading.value
              ? CircularProgressIndicator()
              : ContentWidget(contentData: contentData),
        ],
      ),
    );
  }
}

class ContentWidget extends HookWidget {
  final ValueNotifier<List<dynamic>> contentData;
  const ContentWidget({super.key, required this.contentData});

  @override
  Widget build(BuildContext context) {
    final content = contentData.value;

    return Expanded(
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) {
          return Item(text: content[index]["text"]);
        },
      ),
    );
  }
}

//  --- utils ---
class Item extends HookWidget {
  final String text;
  const Item({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
