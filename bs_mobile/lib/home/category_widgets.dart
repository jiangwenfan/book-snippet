import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/common_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/api_data.dart';
import './utils.dart';
import './content_widgets.dart';

// title widget
class AllTitleWidget extends HookWidget {
  final ValueNotifier<bool> isLoading;
  const AllTitleWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ContentTitle(title: "书摘"),

        // TitleWidget(title: "书摘"),
        SearchWidget(isLoading: isLoading),
      ],
    );
  }
}

// 显示所有标签的widget
class ShowAllLabelsWidget extends HookWidget {
  final ValueNotifier<List<dynamic>> labels;
  const ShowAllLabelsWidget({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children:
            labels.value.map((label) {
              return TextButton(
                onPressed: () {
                  String path = "/snippet?labels=${label["name"]}";
                  GoRouter.of(context).go(path);
                  print("category-跳转到 $path 标签下的书摘列表");
                },
                child: Text(label["name"]),
              );
            }).toList(),
      ),
    );
  }
}

// ---- utils----

class Book extends HookWidget {
  final int categoryId;
  final String bookTiile;
  final int bookCount;
  const Book({
    super.key,
    required this.categoryId,
    required this.bookTiile,

    required this.bookCount,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String path = "/snippet?categoryId=$categoryId&categoryName=$bookTiile";
        GoRouter.of(context).go(path);
        print("category-跳转到 $path 分类下的书摘列表");
      },
      child: Container(
        // margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(bookTiile, style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "$bookCount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
