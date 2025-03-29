import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';
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

  return isLoading.value
      ? [CircularProgressIndicator()]
      : [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 20 / 10,
          padding: EdgeInsets.all(10),
          children:
              allCategory.value.map<Widget>((item) {
                return Book(
                  categoryId: 1,
                  bookTiile: item["name"],
                  bookIcon: Icons.book,
                  bookCount: item["count"],
                );
              }).toList(),
        ),

        // 显示所有labels
        // ShowAllLabelsWidget(labels: allLabels),

        // 显示底部控制栏
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: // 底部工具栏
              BottomInfoBase(
            widget1: null,
            widget2: null,
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
