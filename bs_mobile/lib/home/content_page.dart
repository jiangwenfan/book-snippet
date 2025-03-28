import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './content_widgets.dart';

// AddItem(),
class ContentPage extends HookWidget {
  const ContentPage({super.key});

  Future<void> getLocalData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> content,
  ) async {
    final res = await SharedPreferenceOp.readPartContent();
    if (res != null) {
      content.value = res["results"];
    }

    // 更新到当前状态
    isLoading.value = false;
    print("snippet-从local读取数据成功: ${res?.length}");
  }

  Future<void> getRemoteData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> content,
  ) async {
    print("snippet-从remote读取-写入数据到本地-start-....");
    await getUserLastData();
    print("snippet-从remote读取-写入数据到本地-end-成功");

    await getLocalData(isLoading, content);
  }

  @override
  Widget build(BuildContext context) {
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
          // 1. 用户中心按钮
          UserCenterButton(),

          // 2. 全选按钮
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: () {
              print("点击-全选");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. 标题
          ContentTitle(title: "全部"),

          // 2. 搜索框
          SearchWidget(isLoading: isLoading),

          // 3. 内容列表
          Expanded(
            child: ContentWidget(
              isLoading: isLoading,
              contentData: contentData,
            ),
          ),

          // 显示底部控制栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomInfo(count: contentData.value.length),
            // Container(width: 100, height: 100, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class ContentWidget extends HookWidget {
  final ValueNotifier<List<dynamic>> contentData;
  final ValueNotifier<bool> isLoading;
  const ContentWidget({
    super.key,
    required this.isLoading,
    required this.contentData,
  });

  @override
  Widget build(BuildContext context) {
    final content = contentData.value;

    return isLoading.value
        ? CircularProgressIndicator()
        : ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            return Item(text: content[index]["text"]);
          },
        );
  }
}
