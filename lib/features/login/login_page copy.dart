import 'package:amana_flutter/app/router/app_routes.dart';
import 'package:amana_flutter/features/login/Login_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(loginControllerProvider, (prev, next) {
        if (next.success && next.role != null) {
          _navigateByRole(next.role!);
        }
      });
    });
  }
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.listenManual(loginControllerProvider, (prev, next) {
  //       if (next.success && next.role != null) {
  //         _navigateByRole(next.role!, next.loginResponse);
  //       }
  //     });
  //   });
  // }

  void _navigateByRole(String role) {
    // print('LoginPage = = _navigateByRole  '+role);

    // , Map<String, dynamic>? loginResponse) {
    if (!mounted) return;

    if (role == 'parent') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.parent,
        // arguments: loginResponse,
      );
    } else if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('LoginPage = = build');
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (state.message.isNotEmpty)
                Text(
                  state.message,
                  style: TextStyle(
                    color: state.success ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.loading
                      ? null
                      : () async {
                          await controller.login(
                            usernameCtrl.text,
                            passwordCtrl.text,
                          );
                        },
                  child: state.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
