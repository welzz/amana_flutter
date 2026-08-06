import 'package:shared_preferences/shared_preferences.dart';
import '../router/app_routes.dart';

class AuthGuard {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return token != null;
  }

  static Future<String> getInitialRoute() async {
    final loggedIn = await isLoggedIn();

    if (loggedIn) {
      return AppRoutes.parent;
    } else {
      return AppRoutes.login;
    }
  }
}