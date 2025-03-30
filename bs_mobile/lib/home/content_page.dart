import 'package:bs_mobile/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './content_widgets.dart';

Future<void> refreshContentByCategory(
  String categoryId,
  ValueNotifier<List<dynamic>> content,
) async {
  final resByCategory = await SharedPreferenceOp.readContentByCategory(
    categoryId: categoryId,
  );
  if (resByCategory != null) {
    content.value = resByCategory["results"];
  }
  print("snippet-category过滤-从local读取数据成功: ${resByCategory?['results']}");
}

Future<void> refreshContentByLabels(
  String labels,
  ValueNotifier<List<dynamic>> content,
) async {
  final resByLabels = await SharedPreferenceOp.readContentByLabels(
    labels: labels,
  );
  if (resByLabels != null) {
    content.value = resByLabels["results"];
  }
  print("snippet-labels过滤-从local读取数据成功: ${resByLabels?.length}");
}

Future<void> getLocalData(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> content,
  Map<String, String>? queryPara,
) async {
  if (queryPara != null &&
      queryPara.containsKey("categoryId") &&
      queryPara["categoryId"] != null) {
    // 存在分类参数
    final category = queryPara["categoryId"]!;

    // 从本地读取数据
    await refreshContentByCategory(category, content);

    return;
  }
  if (queryPara != null &&
      queryPara.containsKey("labels") &&
      queryPara["labels"] != null) {
    // 存在标签参数
    final labels = queryPara["labels"]!;

    // 从本地读取数据
    await refreshContentByLabels(labels, content);

    return;
  }

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
  Map<String, String>? queryPara,
) async {
  if (queryPara != null &&
      queryPara.containsKey("categoryId") &&
      queryPara["categoryId"] != null) {
    // 存在分类参数
    final category = queryPara["categoryId"]!;

    // 从远程读取最新数据
    await getUserLastDataByCategory(category);
    await refreshContentByCategory(category, content);
    print("snippet-category过滤-从remote读取数据成功");
    return;
  }
  if (queryPara != null &&
      queryPara.containsKey("labels") &&
      queryPara["labels"] != null) {
    // 存在标签参数
    final labels = queryPara["labels"]!;
    // 从remote读取最新数据
    await getUserLastDataByLabels(labels);
    await refreshContentByLabels(labels, content);
    print("snippet-labels过滤-从remote读取数据成功");
    return;
  }
  print("snippet-从remote读取-写入数据到本地-start-....");
  await getUserLastData();
  print("snippet-从remote读取-写入数据到本地-end-成功");

  await getLocalData(isLoading, content, queryPara);
}

Future<void> loadContentData(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> contentData,
  Map<String, String>? queryPara,
) async {
  final Map<String, String>? queryParaNew;
  // 如果categoryId是0,则清空
  if (queryPara != null &&
      queryPara.containsKey("categoryId") &&
      queryPara["categoryId"] == "0") {
    queryParaNew = {};
  } else {
    queryParaNew = queryPara;
  }
  // 1.1 从本地/全局读取数据，显示
  await getLocalData(isLoading, contentData, queryParaNew);

  // 1.2 获取最新数据
  await getRemoteData(isLoading, contentData, queryParaNew);
}

class ContentPage extends HookWidget {
  final Map<String, String> queryPara;
  const ContentPage({super.key, required this.queryPara});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final contentData = useState([]);

    final contentTile = useState("全部");

    useEffect(() {
      // 当页面加载时，
      loadContentData(isLoading, contentData, queryPara);

      if (queryPara.containsKey("categoryName")) {
        contentTile.value = queryPara["categoryName"]!;
      } else if (queryPara.containsKey("labelsName")) {
        contentTile.value = "#${queryPara["labelsName"]!}";
      }
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => GoRouter.of(context).go("/category"),
          child: Text(
            "书摘",
            style: TextStyle(color: Color.fromARGB(255, 3, 123, 255)),
          ),
        ),
        centerTitle: false,
        leadingWidth: 10,

        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              // 进入分类页面
              print("点击-返回分类页面");
              GoRouter.of(context).go("/category");
            },
            icon: Icon(Icons.arrow_back_ios),
            style: IconButton.styleFrom(padding: EdgeInsets.zero),
            color: Color.fromARGB(255, 3, 123, 255),
          ),
        ),
        actions: [
          // 1. 用户中心按钮
          UserCenterButton(),

          // 2. 全选按钮
          IconButton(
            icon: Icon(Icons.checklist_rounded),
            color: Color.fromARGB(255, 3, 123, 255),
            iconSize: 30,
            onPressed: () {
              print("点击-全选");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 1. 标题
              ContentTitle(title: contentTile.value),
              // 2. 搜索框
              SearchWidget(isLoading: isLoading),
              SizedBox(height: 20),

              Expanded(
                child: // 3. 内容列表
                    ContentWidget(
                  isLoading: isLoading,
                  contentData: contentData,
                ),
              ),
            ],
          ),

          // 显示底部控制栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomInfo(isLoading: isLoading, contentData: contentData),
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
    final content =
        contentData.value
            .map(
              (e) => {
                "text": e["text"],
                "labels": e["labels"],
                // "labels": e["labels"].map((label) => label["name"]).toList(),
              },
            )
            .toList();

    return isLoading.value
        ? CircularProgressIndicator()
        : ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            final List<dynamic> labelsRaw = content[index]["labels"];
            // print("==== $labelsRaw ${labelsRaw.runtimeType}");
            final List<String> labels =
                labelsRaw.map((labelName) => labelName.toString()).toList();
            // print("==== $labels ${labels.runtimeType}");

            return Item(text: content[index]["text"], labels: labels);
          },
        );
  }
}
