import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/api_data.dart';
import './utils.dart';

// title widget
class AllTitleWidget extends HookWidget {
  ValueNotifier<bool> isLoading = useState(true);
  AllTitleWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleWidget(title: "书摘分类"),
        SearchWidget(isLoading: isLoading),
      ],
    );
  }
}

// 显示所有标签的widget
class ShowAllLabelsWidget extends HookWidget {
  final ValueNotifier<List<String>> labels;
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
              // TODO 点击labels进行跳转，跳转到该标签下的书摘列表
              // List<Widget> buildLabels(ValueNotifier<List<dynamic>> allLabels) {
              //   return allLabels.value.map<Widget>((item) {
              //     return TextButton(
              //       onPressed: () {
              //         final label = item["name"];
              //       },
              //       child: Text(item["name"]),
              //     );
              //   }).toList();
              // }

              return Chip(
                label: Text(label),
                backgroundColor: Colors.blue[100],
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
