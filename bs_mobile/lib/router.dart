import 'package:bs_mobile/home/content_page.dart';
import 'package:go_router/go_router.dart';
import 'package:bs_mobile/login/index_page.dart';
import 'package:bs_mobile/home/category_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/home",

  routes: [
    // 登陆首页
    GoRoute(path: "/loginIndex", builder: (context, state) => LoginIndexPage()),
    // 内容页
    GoRoute(path: "/content", builder: (context, state) => ContentPage()),
    // 分类页
    GoRoute(path: "/category", builder: (context, state) => CategoryPage()),
  ],

  redirect: (context, state) {
    // TODO 从riverpod中获取登陆状态
    final bool isLogin = false;

    // 当前路由
    final String currentPath = state.uri.toString();

    // 登陆检查
    if (!isLogin && currentPath != '/loginIndex') {
      // 如果未登陆，且当前不是登陆页，则重定向到登陆页
      return '/loginIndex';
    }
    // 如果已登陆，不做任何处理，继续前往目标页面
    return null;
  },
);
