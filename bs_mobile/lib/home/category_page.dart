import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/common_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/api_data.dart';
import './category_widgets.dart';

Future<void> getLocalData(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> allCategory,
  ValueNotifier<List<dynamic>> allLabels,
) async {
  // 从本地读取分类/标签数据
  final res = await SharedPreferenceOp.readAllCategory();
  final resLabel = await SharedPreferenceOp.readAllLabel();

  isLoading.value = false;

  // 更新到当前状态
  if (res != null) {
    allCategory.value = res["results"];
  }
  print("category-category-从local读取数据成功: ${res?.length}");

  if (resLabel != null) {
    allLabels.value = resLabel["results"];
  }
  print("category-lables-从local读取数据成功: ${resLabel?.length}");
}

Future<void> getRemoteData(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> allCategory,
  ValueNotifier<List<dynamic>> allLabels,
) async {
  print("category-从remote读取-写入数据到本地-start-....");
  await getUserLastData();
  print("category-从remote读取-写入数据到本地-end-成功");

  // 刷新到页面
  await getLocalData(isLoading, allCategory, allLabels);
}

Future<void> loadData(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> allCategory,
  ValueNotifier<List<dynamic>> allLabels,
) async {
  // 获取本地 分类/标签
  await getLocalData(isLoading, allCategory, allLabels);

  // 获取远程 分类/标签
  await getRemoteData(isLoading, allCategory, allLabels);
}

class CategoryPage extends HookWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final allCategory = useState([]);
    final allLabels = useState([]);

    useEffect(() {
      // 当页面加载时，加载数据
      loadData(isLoading, allCategory, allLabels);
    }, []);

    return BasePage(
      title: AllTitleWidget(isLoading: isLoading),
      widget: Stack(
        alignment: Alignment.center,
        children: showMainWidget(isLoading, allCategory, allLabels),
      ),
    );
  }
}

// 显示主要的内容区域
List<Widget> showMainWidget(
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<dynamic>> allCategory,
  ValueNotifier<List<dynamic>> allLabels,
) {
  // test 输出
  final testC = allCategory.value;
  if (testC.isNotEmpty) {
    print("category-category item结构: ${testC[0].toString()}");
  }
  final testL = allLabels.value;
  if (testL.isNotEmpty) {
    print("categoty-labels item结构: ${testL[0].toString()}");
  }
  final allCategoryValue = [
    {"id": 0, "name": "全部", "count": 999},
    ...allCategory.value,
  ];

  return isLoading.value
      ? [CircularProgressIndicator()]
      : [
        ListView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 20 / 10,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              shrinkWrap: true, // 让 GridView 适应内容大小
              physics: NeverScrollableScrollPhysics(), // 禁用 GridView 自己的滚动
              children:
                  allCategoryValue.map<Widget>((item) {
                    return Book(
                      categoryId: item["id"],
                      bookTiile: item["name"],

                      bookCount: item["count"],
                    );
                  }).toList(),
            ),

            SizedBox(height: 20),

            // 显示标签
            Container(
              margin: EdgeInsets.fromLTRB(14, 0, 14, 6),
              alignment: Alignment.topLeft,
              child: Text(
                "标签",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // 显示所有labels
            ShowAllLabelsOfCategoryWidget(labels: allLabels),
          ],
        ),

        // 显示底部控制栏
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: // 底部工具栏
              BottomInfoBase(
            widget1: SizedBox(),
            widget2: SizedBox(),
            table: AddCategoryForm(
              isLoading: isLoading,
              allCategory: allCategory,
              allLabels: allLabels,
            ),
          ),
          // Container(width: 100, height: 100, color: Colors.green),
        ),
      ];
}

// 创建表单
class AddCategoryForm extends HookWidget {
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<List<dynamic>> allCategory;
  final ValueNotifier<List<dynamic>> allLabels;
  const AddCategoryForm({
    super.key,
    required this.isLoading,
    required this.allCategory,
    required this.allLabels,
  });

  @override
  Widget build(BuildContext context) {
    final name = useState("");

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // 取消添加分类
                  // print("点击-取消添加分类");
                  // 取消弹窗
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
              Text("添加分类"),
              TextButton(
                onPressed: () async {
                  // 保存分类
                  print("点击-保存分类: ${name.value}");
                  await ApiData.createCategory(name.value);
                  loadData(isLoading, allCategory, allLabels);
                  // 重新加载数据
                  Navigator.of(context).pop();
                },
                child: Text("保存"),
              ),
            ],
          ),
          TextField(
            onChanged: (value) => name.value = value,
            decoration: InputDecoration(labelText: "分类名称", hintText: "请输入分类名称"),
          ),
          // TextField(
          //   decoration: InputDecoration(labelText: "分类描述", hintText: "请输入分类描述"),
          // ),
        ],
      ),
    );
  }
}

// 显示所有labels的widget
class ShowAllLabelsOfCategoryWidget extends HookWidget {
  final ValueNotifier<List<dynamic>> labels;
  const ShowAllLabelsOfCategoryWidget({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children:
            labels.value.map((label) {
              return GestureDetector(
                onTap: () {
                  // 跳转到书摘列表
                  String path =
                      "/snippet?labels=${label["name"]}&labelsName=${label["name"]}";
                  GoRouter.of(context).go(path);
                  print("category-跳转到 $path 标签下的书摘列表");
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 238, 240),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "#${label["name"]}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 133, 132, 137),
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
