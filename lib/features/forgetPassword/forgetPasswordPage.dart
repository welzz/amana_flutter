import 'package:amana_flutter/core/api/dio_client.dart';
import 'package:amana_flutter/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    DioClient(),
  );
});
class ForgetPasswordPage extends ConsumerStatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ConsumerState<ForgetPasswordPage> createState() =>
      _ForgetPasswordPageState();
}

class _ForgetPasswordPageState
    extends ConsumerState<ForgetPasswordPage> {
  final emailCtrl = TextEditingController();

  bool loading = false;
  String message = '';
  

  Future<void> sendResetEmail() async {
    setState(() {
      loading = true;
      message = '';
    });

    try {
       // =========================
      // SEND TO BACKEND HERE
      // =========================

      // Example:
       final authService = ref.read(authServiceProvider);

    await authService.sendReset(
      emailCtrl.text,
    );
      await Future.delayed(
        const Duration(seconds: 2),
      );

      setState(() {
        print("doneeeee");
        message = 'Reset password link sent successfully';
      });
    } catch (e) {
      setState(() {
        print("nooooooooo");
        message = 'Something went wrong';
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= TOP BLUE AREA =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 40,
                ),

                decoration: const BoxDecoration(
                  color: Color(0xFF1E3E9A),
                ),

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
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),

                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius:
                                BorderRadius.circular(25),

                            border: Border.all(
                              color: Colors.white24,
                            ),
                          ),

                          child: Padding(
                            padding:
                                const EdgeInsets.all(14),

                            child: Image.asset(
                              'assets/images/aman-logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
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
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.white70,
                          ),
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
                      'Reset Your Password',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // ================= BODY =================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 30,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3E9A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                     Text(
                      'login.messageresetemail'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1E3E9A),
                      ),
                    ),

                    const SizedBox(height: 45),

                    // ================= EMAIL =================
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
                      controller: emailCtrl,

                      keyboardType:
                          TextInputType.emailAddress,

                      decoration: InputDecoration(
                        hintText: 'login.enteryourusername'.tr(),

                        hintStyle: TextStyle(
                          color:
                              Colors.blueGrey.shade300,
                          fontSize: 16,
                        ),

                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF1E3E9A),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFF1E3E9A),
                          ),

                          borderRadius:
                              BorderRadius.circular(0),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFF1E3E9A),
                            width: 2,
                          ),

                          borderRadius:
                              BorderRadius.circular(0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= MESSAGE =================
                    if (message.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        child: Text(
                          message,
                          style: TextStyle(
                            color: message.contains(
                                    'successfully')
                                ? Colors.green
                                : Colors.red,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                                  0xFF1E3E9A),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    0),
                          ),
                        ),

                        onPressed: loading
                            ? null
                            : sendResetEmail,

                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,

                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                children: [
                                  Text(
                                    'Send Reset Link',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color:
                                          Colors.white,
                                    ),
                                  ),

                                  SizedBox(
                                      width: 10),

                                  Icon(
                                    Icons.send,
                                    color:
                                        Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= BACK BUTTON =================
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text(
                          'Back to Login',
                          style: TextStyle(
                            color:
                                Color(0xFF1E3E9A),

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 17,
                          ),
                        ),
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