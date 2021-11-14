import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/features/login/ui/pages/login_page.dart';
import 'package:graduation_project/features/register/presentation/pages/register_page.dart';
import 'package:graduation_project/features/splash/ui/pages/splash_page.dart';

class PageRouter {
  static Route<dynamic> route(RouteSettings value) {
    final String? name = value.name;
    switch (name) {
      case SplashPage.route:
        return SplashPage.pageRoute;

      case LoginPage.route:
        return LoginPage.pageRoute;

      case RegisterPage.route:
        return RegisterPage.pageRoute;

      case BasePage.route:
        return BasePage.pageRoute;

      default:
        return _errorRoute(value.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Routing Error!'),
          ),
          body: Center(
            child: Text('ERROR: No page route found for "$routeName"'),
          ),
        );
      },
    );
  }
}
