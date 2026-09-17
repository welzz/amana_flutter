import 'package:amana_flutter/app/router/app_routes.dart';
import 'package:amana_flutter/features/forgetPassword/forgetPasswordPage.dart';
import 'package:amana_flutter/features/login/Login_Controller.dart';
import 'package:easy_localization/easy_localization.dart';
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

  bool obscurePassword = true;

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

  void _navigateByRole(String role) {
    if (!mounted) return;

    if (role == 'parent') {
      Navigator.pushReplacementNamed(context, AppRoutes.parent);
    }else if (role == 'bus') {
      Navigator.pushReplacementNamed(context, AppRoutes.bus);
    } else if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    }else if (role == 'staff') {
      Navigator.pushReplacementNamed(context, AppRoutes.staff);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    // final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===================== TOP BLUE AREA =====================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                decoration: const BoxDecoration(color: Color(0xFF1E3E9A)),

                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.06),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(
                              'assets/images/aman-logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'أمانة',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(width: 12),

                        Text(
                          '|',
                          style: TextStyle(fontSize: 45, color: Colors.white70),
                        ),

                        SizedBox(width: 12),

                        Text(
                          'AMANA',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'login.securepickup'.tr(),
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // ===================== BODY =====================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 30,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'login.WelcomeBack'.tr(),
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3E9A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'login.signmanageyourstudents'.tr(),
                      style: TextStyle(fontSize: 18, color: Color(0xFF1E3E9A)),
                    ),

                    const SizedBox(height: 45),

                    // ================= USERNAME =================
                    Text(
                      'login.username'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3E9A),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: usernameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 16,
                        ),

                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF1E3E9A),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3E9A),
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3E9A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= PASSWORD =================
                    Text(
                      'login.password'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3E9A),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: passwordCtrl,
                      obscureText: obscurePassword,

                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 16,
                        ),

                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1E3E9A),
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF1E3E9A),
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3E9A),
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3E9A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgetPasswordPage(),
                            ),
                          );
                        },

                        child: Text(
                          'login.ForgotPassword'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF1E3E9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ================= ERROR =================
                    if (state.message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: state.success ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // ================= LOGIN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3E9A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),

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
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'login.signin'.tr(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(width: 10),

                                  Icon(Icons.login, color: Colors.white),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ================= LANGUAGE =================
                    Center(
                      child: Container(
                        width: 230,
                        height: 55,
                        padding: const EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1E3E9A)),
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.setLocale(const Locale('en'));
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.locale.languageCode == 'en'
                                        ? const Color(0xFF1E3E9A)
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  child: Center(
                                    child: Text(
                                      'English',
                                      style: TextStyle(
                                        color:
                                            context.locale.languageCode == 'en'
                                            ? Colors.white
                                            : const Color(0xFF1E3E9A),

                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.setLocale(const Locale('ar'));
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.locale.languageCode == 'ar'
                                        ? const Color(0xFF1E3E9A)
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  child: Center(
                                    child: Text(
                                      'العربية',
                                      style: TextStyle(
                                        color:
                                            context.locale.languageCode == 'ar'
                                            ? Colors.white
                                            : const Color(0xFF1E3E9A),

                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 90),

                    // ================= FOOTER =================
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'AMANA DIGITAL CHOICE',
                            style: TextStyle(
                              color: Color(0xFF9AA3C0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Version 2.4.0 • © 2024 All Rights Reserved',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9AA3C0),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
