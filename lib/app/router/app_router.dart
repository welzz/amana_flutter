import 'package:amana_flutter/features/bus_dashboard/BusDashboardPage.dart';
import 'package:amana_flutter/features/staff_dashboard/staff_dashboard_page.dart';
import 'package:flutter/material.dart';
import '../../features/login/login_page.dart';
import '../../features/login/splash_Page.dart';
import '../../features/parent_dashboard/parent_dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());

case AppRoutes.staff:

  return MaterialPageRoute(
    builder: (_) => const StaffDashboardPage(),
  );
  
      case AppRoutes.parent:
        // final loginResponse = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ParentDashboardPage(),
        );
  case AppRoutes.bus:
        // final loginResponse = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BusDashboardPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}
