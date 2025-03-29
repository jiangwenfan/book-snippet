import 'package:bs_mobile/home/category_page.dart';
import 'package:bs_mobile/home/content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 全局基础页面
class BasePage extends HookWidget {
  final Widget widget;
  final Widget? title;
  const BasePage({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // ios风格，关闭居中标题
        toolbarHeight: 130,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: title,
      ),

      body: widget,
    );
  }
}

// 搜索widget
class SearchWidget extends HookWidget {
  final ValueNotifier<bool> isLoading;
  const SearchWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      child: TextField(
        readOnly: isLoading.value ? true : false,
        decoration: InputDecoration(
          hintText: "搜索书摘",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

// 全局标题widget
class TitleWidget extends HookWidget {
  final String title;
  const TitleWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }
}

// home的底部bottom
class BottomInfoBase extends HookWidget {
  final Widget? widget1;
  final Widget? widget2;
  final Widget table;
  const BottomInfoBase({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      // 底部控制栏的背景色
      decoration: BoxDecoration(color: Color.fromARGB(243, 247, 247, 247)),
      child: Row(
        mainAxisAlignment:
            widget1 == null
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceAround,
        children: [
          // widget1!,
          // widget2!,
          if (widget1 != null) widget1!,
          if (widget2 != null) widget2!,
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => table,
              );
            },
            icon: Icon(
              Icons.add,
              size: 30,
              color: Color.fromARGB(255, 1, 123, 253),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomInfo extends HookWidget {
  final ValueNotifier<List<dynamic>> contentData;
  final ValueNotifier<bool> isLoading;
  const BottomInfo({
    super.key,
    required this.isLoading,
    required this.contentData,
  });

  @override
  Widget build(BuildContext context) {
    return BottomInfoBase(
      widget1: Icon(
        Icons.import_export,
        size: 30,
        color: Color.fromARGB(255, 1, 123, 253),
      ),
      widget2: Text(
        "${contentData.value.length}个项目",
        style: TextStyle(fontSize: 17),
      ),
      table: AddItem(contentData: contentData, isLoading: isLoading),
    );
  }
}

// 单个labels显示的widget
class ShowLabelWidget extends HookWidget {
  final Map<String, dynamic> label;
  final int index;
  final Function updateFunction;
  const ShowLabelWidget({
    super.key,
    required this.label,
    required this.index,
    required this.updateFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("addSnippetFrom--点击标签 $label");
        updateFunction(index, !label["checked"]);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              label["checked"]
                  ? Color.fromARGB(255, 0, 123, 255)
                  : Color.fromARGB(255, 238, 238, 240),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: Text(
          "#${label["name"]}",
          style: TextStyle(
            color:
                label["checked"]
                    ? Colors.white
                    : Color.fromARGB(255, 133, 132, 139),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// 显示所有labels
class ShowAllLabelsWidget extends HookWidget {
  /*
    [
      {
       name:"aaa",
       checked: false
      }
    ]
  */
  final ValueNotifier<List<Map<String, dynamic>>> labels;
  const ShowAllLabelsWidget({super.key, required this.labels});

  List<Widget> buildLabels(ValueNotifier<List<Map<String, dynamic>>> labels) {
    List<Widget> labelWidgets = [];

    labels.value.asMap().forEach((index, value) {
      labelWidgets.add(
        ShowLabelWidget(
          label: value,
          index: index,
          updateFunction: updateLabel,
        ),
      );
    });
    return labelWidgets;
  }

  // 更新指定label
  void updateLabel(int index, bool checked) {
    final oldLabels =
        List.from(
          labels.value,
        ).map((e) => {"name": e["name"], "checked": e["checked"]}).toList();

    oldLabels[index]["checked"] = checked;

    labels.value = oldLabels;
  }

  @override
  Widget build(BuildContext context) {
    if (labels.value.isNotEmpty) {
      print("addSnippetFrom--显示labels--item结构-${labels.value[0]}");
    }

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 1,
        runSpacing: 1,
        children: labels.value.isEmpty ? [] : buildLabels(labels),
      ),
    );
  }
}

// 输入创建标签widget
class CreateLabelWidget extends HookWidget {
  final ValueNotifier<List<Map<String, dynamic>>> allLabels;
  final TextEditingController _controller = TextEditingController();

  CreateLabelWidget({super.key, required this.allLabels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          if (value.endsWith(" ")) {
            // 生成最新的标签
            final oldValues =
                List.from(allLabels.value)
                    .map((e) => {"name": e["name"], "checked": e["checked"]})
                    .toList();
            oldValues.add({"name": value, "checked": false});

            allLabels.value = oldValues;

            // 清空输入框
            _controller.clear();
          }
        },
        decoration: InputDecoration(
          hintText: "添加新标签...",
          hintStyle: TextStyle(color: Color.fromARGB(255, 197, 197, 199)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

// form表单文本
class FormText extends HookWidget {
  final String text;
  const FormText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(color: Color.fromARGB(255, 133, 132, 138)),
      ),
    );
  }
}

// bottom 添加书摘widget
class AddItem extends HookWidget {
  final ValueNotifier<List<dynamic>> contentData;
  final ValueNotifier<bool> isLoading;

  AddItem({super.key, required this.isLoading, required this.contentData});

  @override
  Widget build(BuildContext context) {
    final text = useState("");
    // final category = useState(0);
    // final labels = useState([""]);

    // 当前表单使用
    final currentIsLoading = useState(true);
    // [{id: 8, name: 书本1221212, owner: 2, created_dt: 2025-03-29T06:15:27.857252Z, updated_dt: 2025-03-29T06:15:27.857288Z, count: 2},
    final allCategoryRaw = useState([]);
    // [{id: 8, name: 书本1221212,
    final allCategoryShow = useState<List<Map<String, dynamic>>>([{}]);
    final selectedCategoryId = useState<int?>(null);
    // 格式: [{id: 6, name: 34, owner: 2, created_dt: 2025-03-29T06:42:50.025311Z, updated_dt: 2025-03-29T06:42:50.025326Z, count: 1},
    final allLabelsRaw = useState([]);
    final allLabelShow = useState<List<Map<String, dynamic>>>([{}]);

    useEffect(() {
      // 获取全部标签
      loadData(currentIsLoading, allCategoryRaw, allLabelsRaw);
    }, []);

    useEffect(() {
      // 将原生类型处理为显示类型
      allLabelShow.value =
          allLabelsRaw.value
              .map((e) => {"name": e["name"], "checked": false})
              .toList();
    }, [allLabelsRaw.value]);

    useEffect(() {
      // print("---allCategoryRaw.value: ${allCategoryRaw.value}");
      // 将原生类型处理为显示类型
      allCategoryShow.value =
          allCategoryRaw.value
              .map((e) => {"id": e["id"], "name": e["name"]})
              .toList();
    }, [allCategoryRaw.value]);

    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(color: Color.fromARGB(255, 243, 242, 248)),
      child: Column(
        children: [
          // 1. form表单标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: Color.fromARGB(255, 8, 123, 245),
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                "新建书摘",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () async {
                  // 添加书摘
                  print(
                    "添加书摘--${text.value}, ${selectedCategoryId.value}, ${allLabelShow.value}",
                  );
                  // 获取到所有已经被选择的labels
                  final labelsSelected = <String>[];
                  allLabelShow.value.forEach((item) {
                    if (item["checked"] == true) {
                      labelsSelected.add(item["name"]);
                    }
                  });

                  if (selectedCategoryId.value == null) {
                    showSimpleDialogWidget(
                      context: context,
                      title: "提示",
                      content: "请选择分类",
                    );
                    return;
                  }

                  await ApiData.createContent(
                    text.value,
                    selectedCategoryId.value as int,
                    labelsSelected,
                  );
                  // 重新获取数据
                  loadContentData(isLoading, contentData, null);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "添加",
                  style: TextStyle(
                    color: Color.fromARGB(255, 8, 123, 245),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          // 2. 分类相关布局
          Container(
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            // width: 600,
            child: DropdownButton(
              items:
                  allCategoryShow.value.map((item) {
                    return DropdownMenuItem(
                      value: item["id"],
                      child: Text(item["name"]),
                    );
                  }).toList(),

              value: selectedCategoryId.value,
              onChanged: (value) {
                selectedCategoryId.value = value as int?;
                // category.value = value;
                print("选择分类: $value ${value.runtimeType}");
              },
              isExpanded: true, // 让按钮填满宽度
              dropdownColor: Colors.white, // 修改背景颜色
              hint: Text("选择分类"),
            ),
          ),

          // 3. 标签相关布局
          Column(
            children: [
              // 显示标签文本
              FormText(text: "标签"),

              // 显示所有标签
              ShowAllLabelsWidget(labels: allLabelShow),
              // 输入创建标签
              CreateLabelWidget(allLabels: allLabelShow),
            ],
          ),

          SizedBox(height: 15),

          // 4. 书摘句子输入框
          FormText(text: "书摘句子"),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.all(10),
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   color: Colors.yellow,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: TextField(
                maxLines: 3,
                onChanged: (value) => text.value = value,

                decoration: InputDecoration(
                  hintText: "添加书摘句子",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 197, 197, 199),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 全局提示dialog
class SimpleDialogWidget extends HookWidget {
  final String title;
  final String content;
  const SimpleDialogWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("知道了"),
        ),
      ],
    );
  }
}

// 显示全局提示dialog
void showSimpleDialogWidget({
  required BuildContext context,
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialogWidget(title: title, content: content);
    },
  );
}

// 将token存储起来
class TokenOp {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> writeToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  static Future<String?> readToken() async {
    return await storage.read(key: "token");
  }

  // 清空本地所有数据
  static Future<void> clearAll() async {
    await storage.deleteAll();
  }
}

class SharedPreferenceOp {
  // 清空本地数据
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // ---------------写入数据--------------------
  static Future<void> _writeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // 写入所有分类数据
  static Future<void> writeAllCategory(Map<String, dynamic> data) async {
    final key = "allCategory";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 写入所有标签数据
  static Future<void> writeAllLabel(Map<String, dynamic> data) async {
    final key = "allLabel";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 写入本地全部书摘数据
  static Future<void> writePartContent(Map<String, dynamic> data) async {
    final key = "partContent";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 根据分类写入书摘数据
  static Future<void> writeContentByCategory({
    required String categoryId,
    required Map<String, dynamic> data,
  }) async {
    final key = "contentByCategory_$categoryId";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // 根据标签写入书摘数据
  static Future<void> writeContentByLabels({
    required String labels,
    required Map<String, dynamic> data,
  }) async {
    // final labelsString = labels.join(",");

    final key = "contentByLabels_$labels";
    final value = json.encode(data);
    await _writeData(key, value);
  }

  // ---------------读取数据--------------------
  static Future<String?> _readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(key);
    return res;
  }

  // 读取所有分类数据
  static Future<Map<String, dynamic>?> readAllCategory() async {
    final key = "allCategory";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 读取所有标签数据
  static Future<Map<String, dynamic>?> readAllLabel() async {
    final key = "allLabel";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 读取本地全部书摘数据
  static Future<Map<String, dynamic>?> readPartContent() async {
    final key = "partContent";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 根据分类读取书摘数据
  static Future<Map<String, dynamic>?> readContentByCategory({
    required String categoryId,
  }) async {
    final key = "contentByCategory_$categoryId";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }

  // 根据标签读取书摘数据
  static Future<Map<String, dynamic>?> readContentByLabels({
    required String labels,
  }) async {
    // final labelsString = labels.join(",");
    final key = "contentByLabels_$labels";
    final value = await _readData(key);
    return value == null ? null : json.decode(value);
  }
}

// 获取用户最新数据
Future<void> getUserLastData() async {
  // 2.1 获取该用户所有分类
  final res1 = await ApiData.getCategory();
  // 写入全局变量,暂时写到shared_preferences中
  await SharedPreferenceOp.writeAllCategory(res1);

  // 2.2 获取该用户所有标签
  final res2 = await ApiData.getLabel();
  await SharedPreferenceOp.writeAllLabel(res2);

  // 2.3 获取该用户第一页的全部书摘
  final res3 = await ApiData.getAllContent();
  await SharedPreferenceOp.writePartContent(res3);
}

// 获取用户最新的根据category过滤的书摘数据
Future<void> getUserLastDataByCategory(String categoryId) async {
  // 2.2 获取该用户第一页的根据category过滤的书摘数据
  final res3 = await ApiData.getContentByCategoryId(categoryId);
  // 写入到本地
  await SharedPreferenceOp.writeContentByCategory(
    categoryId: categoryId,
    data: res3,
  );
}

// 获取用户最新的根据labels过滤的书摘数据
Future<void> getUserLastDataByLabels(String labels) async {
  // 2.2 获取该用户第一页的根据labels过滤的书摘数据
  final res3 = await ApiData.getContentByLabels(labels);
  // 写入到本地
  await SharedPreferenceOp.writeContentByLabels(labels: labels, data: res3);
}

// 登陆成之后初始化
void loginInit(String token) async {
  // 将token存储起来
  await TokenOp.writeToken(token);
  // 2. 发送请求，获取用户数据
  getUserLastData();
}

// icons
class IconsFont {
  static const String _family = 'IconFont';

  static const IconData wechat = IconData(0xe6ba, fontFamily: _family);
  static const IconData wechatFill = IconData(0xe883, fontFamily: _family);

  static const IconData phone = IconData(0xe634, fontFamily: _family);
  static const IconData phoneFill = IconData(0xe7ca, fontFamily: _family);

  static const IconData google = IconData(0xe602, fontFamily: _family);
  static const IconData googleLogo = IconData(0xe795, fontFamily: _family);
}
