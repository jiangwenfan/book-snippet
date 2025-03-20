import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bs_mobile/utils.dart';
import 'package:bs_mobile/api_data.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allCategory = useState([]);

    Future<void> handleCategory() async {
      try {
        final res = await ApiData.getCategory();
        res as Map<String, dynamic>;
        allCategory.value = res["results"];
      } catch (e) {
        print("获取分类失败...$e");
      }
    }

    useEffect(() {
      // 获取分类
      handleCategory();
    }, []);

    return BasePage(
      title: AllTitleWidget(),
      widget: Stack(
        alignment: Alignment.center,
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 20 / 10,
            padding: EdgeInsets.all(10),
            children: [
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

              // 根据书分类: 显示3行，左右滑动。
              Book(bookTiile: "《活着》", bookIcon: Icons.book, bookCount: 10),
              Book(bookTiile: "《白夜行》", bookIcon: Icons.book, bookCount: 20),
              Book(bookTiile: "《追风筝的人》", bookIcon: Icons.book, bookCount: 30),
              Book(bookTiile: "《解忧杂货店》", bookIcon: Icons.book, bookCount: 40),
              Book(bookTiile: "《小王子》", bookIcon: Icons.book, bookCount: 50),

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
            ],
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
  final String bookTiile;
  final IconData bookIcon;
  final int bookCount;
  const Book({
    super.key,
    required this.bookTiile,
    required this.bookIcon,
    required this.bookCount,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            child: TextButton(
              onPressed: () {
                print("查看该书的所有书摘");
              },
              child: Text("$bookCount >"),
            ),
            // margin: EdgeInsets.only(bottom: 45),
          ),
        ],
      ),
    );
  }
}
