import 'package:dio/dio.dart';
import 'package:bs_mobile/utils.dart';

class ApiData {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8080",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        // 'Authorization': 'Bearer your_token', // 全局 Token
        'Accept': 'application/json', // 默认接受 JSON
      },
      contentType: Headers.jsonContentType, // 默认 Content-Type
      responseType: ResponseType.json, // 响应数据格式
    ),
  );
  // static final String baseUrl = "http://localhost:8080";

  static Future<dynamic> googleLogin(String idToken) async {
    final Response response = await dio.get(
      "/users/login-oauth2-google?id_token=$idToken",
    );
    return response.data;
  }

  // ------------获取用户的分类数据----------
  static Future<dynamic> getCategory() async {
    final Response response = await dio.get(
      "/categories/",
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    print("获取分类数据...${response.data}");
    return response.data;
  }

  // 创建用户的分类数据
  static Future<dynamic> createCategory(String name) async {
    final Response response = await dio.post(
      "/categories/",
      data: {"name": name},
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    return response.data;
  }

  // ------------获取用户的标签数据----------
  static Future<dynamic> getLabel() async {
    final Response response = await dio.get(
      "/labels/",
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    print("获取标签数据...${response.data}");
    return response.data;
  }

  // ------------获取用户的内容数据-----------
  static Future<dynamic> _getContentBase(Map<String, dynamic> query) async {
    final Response response = await dio.get(
      "/snippets/",
      queryParameters: query,
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    return response.data;
  }

  // 获取全部内容
  static Future<dynamic> getAllContent() async {
    final res = await _getContentBase({});
    print("获取全部内容...${res}");
    return res;
  }

  // 根据category_id获取内容
  static Future<dynamic> getContentByCategoryId(String categoryId) async {
    final res = await _getContentBase({"category_id": categoryId});
    print("根据category_id获取内容...${res}");
    return res;
  }

  // 根据labels获取内容
  static Future<dynamic> getContentByLabels(List<String> labels) async {
    final res = await _getContentBase({"labels": labels.join(",")});
    print("根据labels获取内容...${res}");
    return res;
  }

  // 使用search搜索内容
  static Future<dynamic> searchContent(String search) async {
    final res = await _getContentBase({"search": search});
    print("使用search搜索内容...${res}");
    return res;
  }

  // 创建用户的内容数据
  static Future<dynamic> createContent(
    String title,
    String content,
    String categoryId,
    List<String> tags,
  ) async {
    final Response response = await dio.post(
      "/contents/",
      data: {
        "title": title,
        "content": content,
        "category_id": categoryId,
        "tags": tags,
      },
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    return response.data;
  }

  // static Future<Response> register(String username, String password) async {
  //   return await dio.post(
  //     "${baseUrl}/register",
  //     data: {"username": username, "password": password},
  //   );
  // }
}
