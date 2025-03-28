import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/api_data.dart';
import './category_widgets.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({super.key});

  Future<void> getLocalData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> allCategory,
    ValueNotifier<List<String>> allLabels,
  ) async {
    // 从本地读取分类/标签数据
    final res = await SharedPreferenceOp.readAllCategory();
    final resLabel = await SharedPreferenceOp.readAllLabel();

    // 更新到当前状态
    isLoading.value = false;
    if (res != null) {
      allCategory.value = res["results"];
    }
    if (resLabel != null) {
      allLabels.value = resLabel["results"];
    }

    isLoading.value = false;
    print("从 local 显示数据成功");
  }

  Future<void> getRemoteData(
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<dynamic>> allCategory,
    ValueNotifier<List<String>> allLabels,
  ) async {
    // 1. 获取category
    try {
      final res = await ApiData.getCategory();
      // 写入到本地
      await SharedPreferenceOp.writeAllCategory(res);
    } catch (e) {
      print("获取分类失败...$e");
    }

    // 2. 获取标签
    try {
      final res = await ApiData.getLabel();
      // 写入到本地
      await SharedPreferenceOp.writeAllLabel(res);
    } catch (e) {
      print("获取标签失败...$e");
    }
    print("从 remote 获取数据成功");

    // 3. 刷新到页面
    await getLocalData(isLoading, allCategory, allLabels);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final allCategory = useState([]);
    final allLabels = useState([""]);

    useEffect(() {
      // 获取本地 分类/标签
      getLocalData(isLoading, allCategory, allLabels);

      // 获取远程 分类/标签
      getRemoteData(isLoading, allCategory, allLabels);
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
  ValueNotifier<List<String>> allLabels,
) {
  return !isLoading.value
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
                  bookCount: 110,
                );
              }).toList(),
        ),

        // 显示所有labels
        ShowAllLabelsWidget(labels: allLabels),

        // 显示底部控制栏
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: // 底部工具栏
              BottomInfoBase(widget1: null, widget2: null),
          // Container(width: 100, height: 100, color: Colors.green),
        ),
      ];
}
