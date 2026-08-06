import 'dart:convert';
import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/api/dio_client.dart';

class LoginState {
  final bool loading;
  final bool success;
  final String message;
  final bool forgotMode;
  final String? role;
  // final Map<String, dynamic>? loginResponse;

  LoginState({
    this.loading = false,
    this.success = false,
    this.message = '',
    this.forgotMode = false,
    this.role,
    // this.loginResponse,
  });

  LoginState copyWith({
    bool? loading,
    bool? success,
    String? message,
    bool? forgotMode,
    String? role,
    Map<String, dynamic>? loginResponse,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      message: message ?? this.message,
      forgotMode: forgotMode ?? this.forgotMode,
      role: role ?? this.role,
      // loginResponse: loginResponse ?? this.loginResponse,
    );
  }
}

final authServiceProvider = Provider((ref) {
          //  print('LoginController = = authServiceProvider');

  return AuthService(DioClient());
});

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
        //  print('LoginController = = loginControllerProvider');

  return LoginController(
    ref.read(authServiceProvider),
    ref,
  );
});
class LoginController extends StateNotifier<LoginState> {
  final AuthService authService;
final Ref ref;
  LoginController(this.authService, this.ref) : super(LoginState());
//   Future<void> login(String username, String password) async {
//     print('LoginController = = Future<void> login');
//     state = state.copyWith(loading: true, message: '');

//     try {
//       final res = await authService.login(username, password);
// // ref.read(loginSessionProvider.notifier).state = res;
// ref.read(loginSessionProvider.notifier).state = 
//     Map<String, dynamic>.from(res);
// // print(ref.read(loginSessionProvider));
// // print("SESSION => ${ref.read(loginSessionProvider)}");
//       final token = res['token'];
//       final role = res['role'];
//       final rawUserId = res['userId'] ?? res['id'] ?? (res['user']?['id']);
//       final userId = rawUserId is int
//           ? rawUserId
//           : int.tryParse(rawUserId?.toString() ?? '');

//       if (token == null) {
//         throw Exception('No token returned');
//       }

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token.toString());
//       await prefs.setString('role', role?.toString() ?? '');
//       // await prefs.setString('loginResponse', jsonEncode(res));
//       if (userId != null) {
//         await prefs.setInt('userId', userId);
//       }

//       state = state.copyWith(
//         loading: false,
//         success: true,
//         role: role?.toString(),
         
//         message: 'Login Success',
//       );
//     } catch (e) {
//       state = state.copyWith(
//         loading: false,
//         success: false,
//         message: 'Invalid username or password',
//         role: null,
//         loginResponse: null,
//       );
//     }
//   }

Future<void> login(String username, String password) async {

  state = LoginState(
    loading: true,
  );

  try {
    final res = await authService.login(username, password);

    ref.read(loginSessionProvider.notifier).state =
        Map<String, dynamic>.from(res);

    final token = res['token'];
    final role = res['role'];

    if (token == null) {
      throw Exception('No token returned');
    }

    state = state.copyWith(
      loading: false,
      success: true,
      role: role?.toString(),
      message: 'Login Success',
    );

  } catch (e) {

    ref.read(loginSessionProvider.notifier).state = null;

    state = state.copyWith(
      loading: false,
      success: false,
      message: 'Invalid username or password',
      role: null,
    );
  }
}
  Future<void> sendReset(String username) async {
    state = state.copyWith(loading: true);

    try {
      await authService.sendReset(username);

      state = state.copyWith(
        loading: false,
        message: 'Reset link sent',
        success: true,
        forgotMode: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        message: 'Error sending reset',
        success: false,
      );
    }
  }

  void toggleForgot() {
    state = state.copyWith(forgotMode: !state.forgotMode);
  }
}
