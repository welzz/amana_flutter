import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/student.dart';
import 'buscontroller.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../app/router/app_routes.dart';

class BusDashboardPage extends ConsumerStatefulWidget {
  const BusDashboardPage({super.key});

  @override
  ConsumerState<BusDashboardPage> createState() => _BusDashboardPageState();
}

class _BusDashboardPageState extends ConsumerState<BusDashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print('Calling loadStudents');
      _loadParentData();
    });
  }

  Future<void> _loadParentData() async {
     if (!mounted) return;
    final controller = ref.read(busControllerProvider.notifier);

  await controller.loadStudents();

   }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(busControllerProvider);
    final controller = ref.read(busControllerProvider.notifier);
    final loginResponse = ref.watch(loginSessionProvider);

    final isArabic = context.locale.languageCode == 'ar';

    final userName = isArabic
        ? (loginResponse?['name'] ?? 'مستخدم')
        : (loginResponse?['firstNameEn'] ?? 'Driver');

    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF1E3F95),
                    child: Column(
                      children: [
                          Text(
                         '👋 ${'parentDashboard.welcome'.tr()}, $userName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
const SizedBox(height: 10),

 
                        const SizedBox(height: 10),

                       
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Send All Button
                  Row(
  children: [
    Expanded(
      child: Text(
        '${state.students.length} Students',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E3F95),
        ),
      ),
    ),
    SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3F95),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed:
            state.students.isEmpty ||
            state.disableIamButtonHere
        ? null
        : () async {
            await controller.sendAllStudents();
          },
        icon: const Icon(Icons.send, size: 18),
        label: Text(
          state.disableIamButtonHere
              ? 'Sent'
              : 'Send',
        ),
      ),
    ),
  ],
),
                  const SizedBox(height: 20),

                  // Students List
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.students.length,
                      itemBuilder: (context, index) {
                        final student = state.students[index];

                        return _StudentCard(student: student,  isArabic: isArabic);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _toggleLanguage() {
    if (context.locale.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  final bool isArabic;

  const _StudentCard({
    required this.student,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1E3F95),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3F95).withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF1E3F95),
              size: 32,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? student.name
                      : student.nameEn,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3F95),
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.school,
                      size: 16,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                       isArabic
                      ? student.classroom?? ''
                      : student.classroomEn?? '',
                    
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

                  ],
      ),
    );
  }
}