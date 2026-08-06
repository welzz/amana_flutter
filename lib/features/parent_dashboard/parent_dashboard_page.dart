import 'dart:convert';
import 'dart:async';
import 'package:amana_flutter/features/delegations/delegationPage.dart';
import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:amana_flutter/models/student.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/router/app_routes.dart';
import 'parent_controller.dart';
import 'package:amana_flutter/core/services/socket_provider.dart';

class ParentDashboardPage extends ConsumerStatefulWidget {
  const ParentDashboardPage({super.key});

  @override
  ConsumerState<ParentDashboardPage> createState() =>
      _ParentDashboardPageState();
}

class _ParentDashboardPageState extends ConsumerState<ParentDashboardPage> {
  bool _pickupSubscribed = false;

  @override
  void initState() {
    super.initState();

    ref.read(geoServiceProvider.notifier).initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadParentData();
    });
  }

 Future<void> _loadParentData() async {
  final loginResponse = ref.read(loginSessionProvider);
  if (loginResponse == null) return;

  ref
      .read(parentControllerProvider.notifier)
      .setSelectedSchoolFromLoginResponse(loginResponse);

  final schoolId = loginResponse['schoolId'];

  if (!mounted) return;

  if (schoolId != null) {
    await ref
        .read(parentControllerProvider.notifier)
        .loadData(schoolId);

    if (!_pickupSubscribed) {
      final parentId = loginResponse['parentId'];

      final socket = ref.read(busSocketServiceProvider);

await socket.waitUntilConnected();

socket.subscribeToPickupStatus(
  parentId,
  (json) {
    ref
        .read(parentControllerProvider.notifier)
        .pickupStatusChanged(json);
  },
);

      _pickupSubscribed = true;
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parentControllerProvider);
    final controller = ref.read(parentControllerProvider.notifier);
    final isNearSchool = ref.watch(isNearAnySchoolProvider);
    print(state.busLat);
final busLat = state.busLat;
final busLng = state.busLng;
    final loginResponse = ref.watch(loginSessionProvider);
    final isArabic = context.locale.languageCode == 'ar';

    final userName = isArabic
        ? (loginResponse?['name'] ?? loginResponse?['name'] ?? 'مستخدم')
        : (loginResponse?['firstNameEn'] ?? 'User');

    // final userName = loginResponse?['name'] ?? 'User';

    final children = state.children;
    final pickupRequests = state.pickupRequests;

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final activePickupRequests = pickupRequests
        .where((r) => r.status != PickupStatus.Completed)
        .length;
    return Scaffold(
      appBar: AppBar(
        title: Text('parentDashboard.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _openNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),

      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= TOP HEADER =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:  Color(0xFF1E3F95),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: [
                        // TOP ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // LOGO
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/aman-logo.png',
                                  height: 40,
                                ),

                                const SizedBox(width: 10),

                                  Text(
                                  'login.amana'.tr(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color:  Color.fromARGB(255, 255, 255, 255)
                                  ),
                                ),
                              ],
                            ),

                            // LANGUAGE
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Text(
                          '👋 ${'parentDashboard.welcome'.tr()}, $userName',
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color:  Color.fromARGB(255, 255, 255, 255)
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'login.securepickup'.tr(),
                          style: TextStyle(fontSize: 18, color:   Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= STATS =================
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          number: '${children.length}',
                          title: 'parentDashboard.childrent'.tr(),
                          
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: _buildStatCard(
                          number: '$activePickupRequests',
                          title: 'status.awaiting'.tr(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  

                  // ================= LOCATION STATUS =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isNearSchool
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: isNearSchool ? Colors.green : Colors.orange,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isNearSchool
                              ? const Color.fromARGB(255, 246, 0, 0)
                              : Colors.orange,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            isNearSchool
                                ? 'parentDashboard.Schoolisnear'.tr()
                                : 'parentDashboard.Schoolisnotnear'.tr(),

                            style: TextStyle(
                              color: isNearSchool
                                  ? Colors.green
                                  : Colors.orange,

                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

if (busLat != null && busLng != null)
  SizedBox(
    height: 250,
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(busLat, busLng),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('bus'),
          position: LatLng(busLat, busLng),
          infoWindow: const InfoWindow(
            title: 'School Bus',
          ),
        ),
      },
    ),
  ),

  const SizedBox(height: 20),
                  const SizedBox(height: 28),

                    Text(
                    'parentDashboard.pickupstate'.tr(),
                    style: TextStyle(
                      color:  Color(0xFF1E3F95),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ================= CHILDREN =================
                  ...children.map((child) {
                    final status = getChildStatus(
                      child: child,
                      requests: pickupRequests,
                    );

                    return _buildChildCard(
                      child: child,
                      status: status,
                      controller: controller,
                      pickupRequests: pickupRequests,
                      isArabic: isArabic,
                      isNearSchool:isNearSchool,
                    );
                  }),

                  // ================= QUICK ACTIONS =================
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [    // CREATE DELEGATION BUTTON
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>   CreateDelegationPage( students: List<Student>.from(children),),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF1E3F95),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.assignment_ind,
              size: 50,
              color: Color(0xFF1E3F95),
            ),

            const SizedBox(height: 14),

              Text(
              'delegation.createDelegation'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E3F95),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= LANGUAGE =================
  void _toggleLanguage() {
    if (context.locale.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }

  // ================= NOTIFICATIONS =================
  void _openNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🔔 Notifications', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Pickup request updated'),
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Child released successfully'),
              ),
            ],
          ),
        );
      },
    );
  }

  PickupStatus? getChildStatus({
    required Student child,
    required List<PickupRequest> requests,
  }) {
    try {
      final request = requests.firstWhere(
        (r) => r.studentId.toString() == child.id.toString(),
      );
      return request.status;
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  String translate_status(String name) {
    switch (name) {
      case 'Awaiting':
        return 'status.awaiting'.tr();
      case 'ChildReleased':
        return 'status.childReleased'.tr();
      case 'Completed':
        return 'status.completed'.tr();
      default:
        return name;
    }
  }

  Widget _buildStatCard({required String number, required String title}) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color : Color(0xFF1E3F95)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              color:  Color(0xFF1E3F95),
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E3F95),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard({
    required Student child,
    required PickupStatus? status,
    required dynamic controller,
    required List<PickupRequest> pickupRequests,
    required bool isArabic,
       required bool isNearSchool,
  }) {
    final statusText = status == PickupStatus.Awaiting
        ? 'AWAITING'
        : status == PickupStatus.ChildReleased
        ? 'RELEASED'
        : 'COMPLETED';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Color(0xFF1E3F95))),
      child: Column(
        children: [
          Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    // ================= LEFT COLUMN =================
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // NAME
          Text(
            isArabic ? child.name : child.nameEn,
            style: const TextStyle(
              color: Color(0xFF1E3F95),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // CLASSROOM
          Text(
            '${child.classroomEn ?? child.classroom} • ID ${child.id}',
            style: const TextStyle(
              color: Color(0xFF1E3F95),
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: status == PickupStatus.Awaiting
                  ? Colors.orange.withOpacity(0.15)
                  : status == PickupStatus.ChildReleased
                      ? Colors.blue.withOpacity(0.15)
                      : Colors.green.withOpacity(0.15),

              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              translate_status(status?.name ?? ''),
              style: TextStyle(
                color: status == PickupStatus.Awaiting
                    ? Colors.orange
                    : status == PickupStatus.ChildReleased
                        ? Colors.blue
                        : Colors.green,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),

    const SizedBox(width: 20),

    // ================= RIGHT COLUMN =================
    Column(
      children: [

        // IMAGE
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF1E3F95),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: child.pictureUrl != null &&
                  child.pictureUrl!.isNotEmpty

              ? Image.memory(
                  base64Decode(
                    child.pictureUrl!.split(',').last,
                  ),
                  fit: BoxFit.cover,
                )

              : const Icon(
                  Icons.person_outline,
                  color: Color(0xFF1E3F95),
                  size: 36,
                ),
        ),

        const SizedBox(height: 14),

        // BUTTON / STATUS BOX
        SizedBox(
          width: 140,
          height: 44,

          child: status != null &&
                  status != PickupStatus.ChildReleased

              // STATUS BOX
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: status == PickupStatus.Awaiting
                          ? Colors.orange
                          : Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    translate_status(status.name),
                    style: TextStyle(
                      color: status == PickupStatus.Awaiting
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )

              // BUTTON
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF1E3F95),
                    ),
                  ),
                  onPressed: !isNearSchool
                      ? null
                      : () {
                          controller.notifyPickup(
                            child,
                            pickupRequests,
                          );
                        },
                  child: Text(
                    status == PickupStatus.ChildReleased
                        ? 'confirm.released'.tr()
                        : 'parentDashboard.imHere'.tr(),

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Color(0xFF1E3F95),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
    ),
  ],
),

         
        ],
      ),
    );
  }
}
