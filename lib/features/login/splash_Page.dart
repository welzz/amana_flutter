import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final role = prefs.getString('role');
    final storedLoginResponse = prefs.getString('loginResponse');

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    Map<String, dynamic>? loginResponse;

    try {
      if (storedLoginResponse != null &&
          storedLoginResponse.isNotEmpty) {
        final decoded = jsonDecode(storedLoginResponse);

        if (decoded is Map<String, dynamic>) {
          loginResponse = decoded;
        }
      }
    } catch (e) {
      debugPrint('Decode Error: $e');
    }

    switch (role?.toLowerCase()) {
      case 'parent':
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.parent,
          arguments: loginResponse,
        );
        break;

      case 'admin':
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.admin,
          arguments: loginResponse,
        );
        break;

      default:
        Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          // Top Left Circle
          Positioned(
            top: -120,
            left: -140,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EBF2),
                borderRadius: BorderRadius.circular(220),
              ),
            ),
          ),

          // Top Center Rounded Shape
          Positioned(
            top: 170,
            left: 60,
            right: 60,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEF2),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),

          // Bottom Rounded Shape
          Positioned(
            bottom: 160,
            left: 60,
            right: 60,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEF2),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),

          // Right Bottom Circle
          Positioned(
            bottom: 120,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EBF2),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Border
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF1F3D99),
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 170,
                      height: 170,
                      color: const Color(0xFF1F3D99),
                      child: Image.asset(
  'assets/images/aman-logo.png',
  width: 120,
),
                      // const Icon(
                      //   Icons.shield,
                      //   size: 70,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'أمانة',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3D99),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'AMANA',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F3D99),
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F3D99),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 220),

                  const Text(
                    'POWERED BY',
                    style: TextStyle(
                      color: Color(0xFF9AA3C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                    Text(
                    'login.digitalchoice'.tr(),
                    style: TextStyle(
                      color: Color(0xFF1F3D99),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 