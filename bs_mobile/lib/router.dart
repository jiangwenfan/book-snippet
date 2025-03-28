import 'package:bs_mobile/home/content_page.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/login/index_page.dart';
import 'package:bs_mobile/home/category_page.dart';
import 'package:bs_mobile/user/user_page.dart';
import 'package:bs_mobile/utils.dart';

final GoRouter router = GoRouter(
  initialLocation: "/snippet",

  routes: [
    // 登陆首页
    GoRoute(path: "/loginIndex", builder: (context, state) => LoginIndexPage()),

    // 内容页,默认进入
    GoRoute(path: "/snippet", builder: (context, state) => ContentPage()),
    // 分类页
    GoRoute(path: "/category", builder: (context, state) => CategoryPage()),

    // 用户页
    GoRoute(path: "/user", builder: (context, state) => UserPage()),
  ],

  redirect: (context, state) async {
    // 建议: 从 riverpod 中获取登陆状态
    final token = await TokenOp.readToken();
    final bool isLogin = token != null;

    // 当前路由
    final String currentPath = state.uri.toString();

    // 登陆检查
    if (!isLogin && currentPath != '/loginIndex') {
      // 如果未登陆，且当前不是登陆页，则重定向到登陆页
      print("进入:${currentPath}页面,失败(为登陆),重定向到登陆页/loginIndex");
      return '/loginIndex';
    }
    // 如果已登陆，不做任何处理，继续前往目标页面
    print("进入:${currentPath}页面,成功");
    return null;
  },
);
