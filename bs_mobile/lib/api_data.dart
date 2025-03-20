import 'package:dio/dio.dart';
import 'package:bs_mobile/utils.dart';

class ApiData {
  static final Dio dio = Dio();
  static final String baseUrl = "http://localhost:8080";

  static Future<dynamic> googleLogin(String idToken) async {
    final Response response = await dio.get(
      "$baseUrl/users/login-oauth2-google?id_token=$idToken",
    );
    return response.data;
  }

  static Future<dynamic> getCategory() async {
    final Response response = await dio.get(
      "$baseUrl/categories/",
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
