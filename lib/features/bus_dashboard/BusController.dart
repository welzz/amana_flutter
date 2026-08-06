import 'dart:async';

import 'package:amana_flutter/core/config/app_config.dart';
import 'package:amana_flutter/core/services/BusSocketService.dart';
import 'package:amana_flutter/core/services/GeoLocationService.dart';
import 'package:amana_flutter/core/services/PickupService.dart';
import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:amana_flutter/models/bus.dart';
import 'package:amana_flutter/models/student.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'busstate.dart';
import '../../core/services/bus_service.dart';
import '../../core/services/socket_provider.dart';

 
final pickupServiceProvider = Provider<PickupService>((ref) {
  final baseUrl = AppConfig.baseUrl;

  return PickupService(baseUrl: baseUrl);
});


final geoServiceProvider =
    StateNotifierProvider<GeoLocationsService, Map<String, double>?>(
  (ref) => GeoLocationsService(),
);

final busControllerProvider = StateNotifierProvider<BusController, BusState>((
  ref,
) {
  return BusController(
    ref,
    ref.read(busRepositoryProvider),
    ref.read(pickupServiceProvider),
      ref.read(busSocketServiceProvider),
  );
});

class BusController extends StateNotifier<BusState> {
  final Ref ref;
  final BusRepository repository;
  final PickupService _pickupService;
   final BusSocketService _socket;
 
Timer? _trackingTimer;
bool _trackingStarted = false;

BusController(
  this.ref,
  this.repository,
  this._pickupService,
  this._socket,
) : super(const BusState());

  Future<void> loadStudents() async {
    //  print('loadStudents started');
    state = state.copyWith(loading: true);
    //  print('loadStudents started11111');

    try {
      //  print('loadStudents started22222');

      final loginResponse = ref.read(loginSessionProvider);
      //  print('loadStudents started33333');

      if (loginResponse == null) {
        state = state.copyWith(loading: false);
        return;
      }
      final userId = loginResponse['userId'];
      final schoolId = loginResponse['schoolId'];

      final List<Bus> currentbus = await repository.loadBusByUserId(userId);

      final List<PickupRequest> pickupRequests = await _pickupService
          .loadSPickupRequestToday(schoolId);

      final today = DateTime.now();
      //  print(today);
      final bool disableImHereButton = pickupRequests.any((req) {
        final arrival = req.arrivalTime;
        //  print(req);

        return arrival.year == today.year &&
            arrival.month == today.month &&
            arrival.day == today.day &&
            req.buspickup == true;
      });
      //  print('after loadSPickupRequestToday');
      if (currentbus.isEmpty) {
        state = state.copyWith(loading: false, students: []);
        return;
      }

      final Bus currentBusfirst = currentbus.first;
      print('xxxxx');

      List<Student> studentsonbus = getStudentsOnBus(
        currentBusfirst.students,
        pickupRequests,
      );
      state = state.copyWith(
        loading: false,
        bus: currentBusfirst,
        students: studentsonbus,
        disableIamButtonHere: disableImHereButton,
      );

      await startTracking();
    } catch (e) {
      // print('errorrrrrrrrrrrrrrrrrrrrrr');

      // print(s);

      state = state.copyWith(loading: false, students: []);
    }
  }

  List<Student> getStudentsOnBus(
    List<Student> allStudents,
    List<PickupRequest> pickupRequests,
  ) {
    // print('getStudentsOnBus');

    final today = DateTime.now();

    bool isSameDay(DateTime date) {
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }

    // print(pickupRequests.length);

    // الطلاب الذين سيأخذهم ولي الأمر اليوم
    final parentPickupStudentIds = pickupRequests
        .where(
          (r) =>
              r.buspickup == false &&
              r.arrivalTime != null &&
              isSameDay(r.arrivalTime!),
        )
        .map((r) => r.studentId)
        .toSet();
    // print(parentPickupStudentIds);
    return allStudents.where((s) => !parentPickupStudentIds.contains(s.id)).map(
      (student) {
        PickupRequest? request;
        // print(student);
        try {
          request = pickupRequests.firstWhere(
            (r) =>
                r.studentId == student.id &&
                
                isSameDay(r.arrivalTime!) &&
                (r.status == PickupStatus.Awaiting ||
                    r.status == PickupStatus.ChildReleased),
          );
        } catch (_) {
          request = null;
        }
        // print(request?.studentId);
        //   print(request?.status);
        return student.copyWith(pickupStatus: request?.status);
      },
    ).toList();
  }

  Future<void> sendAllStudents() async {
    await repository.sendStudents(state.students,state.bus);

    loadStudents();

  }

Future<void> startTracking() async {
  if (_trackingStarted) return;
  _trackingStarted = true;

  await ref.read(geoServiceProvider.notifier).initialize();

  // ⛔ استنى socket يجهز
  while (!_socket.isConnected) {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  _trackingTimer?.cancel();

  _trackingTimer = Timer.periodic(
    const Duration(seconds: 5),
    (timer) async {
      final current = ref.read(geoServiceProvider);

      if (current == null || state.bus == null) return;
print(state.bus);
      _socket.sendLocation(
        state.bus!.id,
        current['lat']!,
        current['lon']!,
      );
    },
  );
}

@override
void dispose() {
   _trackingStarted = false;
_trackingTimer?.cancel();
_socket.disconnect();
  super.dispose();


}
}
