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

  // **静态构造函数**，在类加载时执行一次
  static void _initialize() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.response?.statusCode == 400) {
            print("🔥 400 错误: ${e.response?.data}");
          }
          return handler.next(e);
        },
      ),
    );
  }

  // **保证静态构造函数执行**
  static void init() {
    _initialize();
  }

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
    print("创建分类数据...${response.data}");
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
  static Future<dynamic> getContentByLabels(String labels) async {
    final res = await _getContentBase({"labels": labels});
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
    String content,
    int categoryId,
    List<String> tags,
  ) async {
    ApiData.init();
    final Response response = await dio.post(
      "/snippets/",
      data: {"text": content, "category": categoryId, "labels": tags},
      options: Options(
        headers: {"Authorization": "Bearer ${await TokenOp.readToken()}"},
      ),
    );
    print("创建内容数据...${response.data}");
    return response.data;
  }

  // static Future<Response> register(String username, String password) async {
  //   return await dio.post(
  //     "${baseUrl}/register",
  //     data: {"username": username, "password": password},
  //   );
  // }
}
