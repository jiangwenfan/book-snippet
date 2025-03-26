import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/api_data.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({super.key});

  Future<void> handleCategory() async {
    try {
      final res = await ApiData.getCategory();
      res as Map<String, dynamic>;
      allCategory.value = res["results"];
    } catch (e) {
      print("获取分类失败...$e");
    }
  }

  List<Widget> buildCategory(ValueNotifier<List<dynamic>> allCategory) {
    return allCategory.value.map<Widget>((item) {
      return Book(
        categoryId: 1,
        bookTiile: item["name"],
        bookIcon: Icons.book,
        bookCount: 110,
      );
    }).toList();
  }

  List<Widget> buildLabels(ValueNotifier<List<dynamic>> allLabels) {
    return allLabels.value.map<Widget>((item) {
      return TextButton(
        onPressed: () {
          final label = item["name"];
          // TODO 跳转到该标签下的书摘列表
        },
        child: Text(item["name"]),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final allCategory = useState([]);
    final allLabels = useState([]);

    useEffect(() {
      // 获取分类
      handleCategory();
    }, []);

    return BasePage(
      title: AllTitleWidget(),
      widget:
          !isLoading.value
              ? CircularProgressIndicator()
              : Stack(
                alignment: Alignment.center,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 20 / 10,
                    padding: EdgeInsets.all(10),

                    children: buildCategory(allCategory),
                    // children: [
                    // Container(
                    //   margin: EdgeInsets.all(10),
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {
                    //       print("查看全部");
                    //     },
                    //     label: Text("全部"),
                    //     icon: Icon(Icons.list),
                    //     style: ButtonStyle(
                    //       backgroundColor: WidgetStateProperty.all(Colors.white),
                    //       textStyle: WidgetStateProperty.all(
                    //         TextStyle(color: Colors.black, fontSize: 20),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // allCategory.value.isEmpty
                    //     ? CircularProgressIndicator()
                    //     : Column(
                    //       children:
                    //           allCategory.value.map<Widget>((item) {
                    //             return Book(
                    //               bookTiile: item["name"],
                    //               bookIcon: Icons.book,
                    //               bookCount: 110,
                    //             );
                    //           }).toList(),
                    //     ),
                    // TODO 根据标签分类：显示3行，左右滑动。
                    // ],
                  ),

                  // labels
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: buildLabels(allLabels),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: // 底部工具栏
                        BottomInfoBase(widget1: null, widget2: null),
                    // Container(width: 100, height: 100, color: Colors.green),
                  ),
                ],
              ),
    );
  }
}

class AllTitleWidget extends HookWidget {
  const AllTitleWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [TitleWidget(title: "书摘分类"), SearchWidget()],
    );
  }
}

// ---- utils----

class Book extends HookWidget {
  final int categoryId;
  final String bookTiile;
  final IconData bookIcon;
  final int bookCount;
  const Book({
    super.key,
    required this.categoryId,
    required this.bookTiile,
    required this.bookIcon,
    required this.bookCount,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("跳转到该分类下的书摘列表");
        GoRouter.of(context).go("/content");
      },
      child: Container(
        // width: 30,
        // height: 20,
        // color: Colors.green,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(bookIcon, size: 30),
                Text(bookTiile, style: TextStyle(fontSize: 15)),
              ],
            ),
            Text("$bookCount >"),
            // Container(
            //   child: TextButton(
            //     onPressed: () {
            //       print("查看该书的所有书摘");
            //     },
            //     child: Text("$bookCount >"),
            //   ),

            //   // margin: EdgeInsets.only(bottom: 45),
            // ),
          ],
        ),
      ),
    );
  }
}
