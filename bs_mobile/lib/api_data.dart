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
      "/tags/",
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    return response.data;
  }

  // ------------获取用户的内容数据-----------
  static Future<dynamic> _getContentBase(Map<String, dynamic> query) async {
    final Response response = await dio.get(
      "/contents/",
      queryParameters: query,
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    return response.data;
  }

  // 获取全部内容
  static Future<dynamic> getAllContent() async {
    return await _getContentBase({});
  }

  // 根据category_id获取内容
  static Future<dynamic> getContentByCategoryId(String categoryId) async {
    return await _getContentBase({"category_id": categoryId});
  }

  // 根据labels获取内容
  static Future<dynamic> getContentByLabels(List<String> labels) async {
    return await _getContentBase({"labels": labels.join(",")});
  }

  // 使用search搜索内容
  static Future<dynamic> searchContent(String search) async {
    return await _getContentBase({"search": search});
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
