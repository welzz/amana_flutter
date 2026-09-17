import 'package:amana_flutter/core/config/app_config.dart';
import 'package:amana_flutter/core/services/ParentBusSocketService.dart';
import 'package:amana_flutter/core/services/PickupService.dart';
import 'package:amana_flutter/core/services/adminservice.dart';
import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:amana_flutter/features/parent_dashboard/parent_api.dart.dart';
import 'package:amana_flutter/core/services/GeoLocationService.dart';
import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:amana_flutter/models/student.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parent_state.dart';
import '../../models/school.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl =  AppConfig.baseUrl;

  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  return dio;
});

final parentApiProvider = Provider<ParentApi>((ref) {
  // print('parentcontroler = = parentApiProvider');

  final dio = ref.watch(dioProvider);
  return ParentApi(dio);
});
final pickupServiceProvider = Provider<PickupService>((ref) {
  // final dio = ref.watch(dioProvider);

  final baseUrl = AppConfig.baseUrl;

  return PickupService(  baseUrl: baseUrl);
});

final adminServiceProvider = Provider<AdminService>((ref) {
  final baseUrl =  AppConfig.baseUrl;

  return AdminService(baseUrl: baseUrl);
});

final parentControllerProvider =
    StateNotifierProvider<ParentController, ParentState>(
      (ref) => ParentController(ref),
    );

final geoServiceProvider =
    StateNotifierProvider<GeoLocationsService, Map<String, double>?>(
      (ref) => GeoLocationsService(),
    );
final selectedSchoolProvider = StateProvider<School?>((ref) => null);

// final currentCoordsProvider     =
//     StateNotifierProvider<GeoLocationsService, Map<String, double>?>(
//   (ref) => GeoLocationsService(),
// );
final isNearAnySchoolProvider = Provider<bool>((ref) {
  // print('parentcontroler = = isNearAnySchoolProvider');

  final school = ref.watch(selectedSchoolProvider);
  final coords = ref.watch(geoServiceProvider);

  if (school == null || school.geofence.isEmpty || coords == null) {
    return false;
  }

  final geo = ref.watch(geoServiceProvider.notifier);

  final polygon = school.geofence
      .map((p) => {'lat': p.lat, 'lon': p.lon})
      .toList();

  return geo.isPointInPolygon(coords, polygon);
});

class ParentController extends StateNotifier<ParentState> {
  final Ref ref;
final ParentBusSocketService _socket =
    ParentBusSocketService();
  ParentController(this.ref) : super(ParentState());

  Future<void> loadData(int schoolid) async {
    // print('parentcontroler = = loadData');

    state = ParentState(
      loading: true,
      children: [],
      pickupRequests: [],
      error: null,
    );

    try {
      final api = ref.read(parentApiProvider);
      final loginResponse = ref.read(loginSessionProvider);

      final pickupRequests = await api.getPickupBySchoolIdToday(schoolid);
      final requests = (pickupRequests)
          .map((e) => PickupRequest.fromJson(e))
          .toList();
      // print(loginResponse?['students']);
      final children = ((loginResponse?['students'] ?? []) as List)
          .map((e) => Student.fromJson(e))
          .toList();
      state = state.copyWith(
        loading: false,
        children: children,
        pickupRequests: requests,

        error: null,
      );


      if (children.isNotEmpty &&
    children.first.busId != null) {

  listenBusLocation(
    int.parse(children.first.busId!),
  );
  final parentId = loginResponse?['parentId'];

if (parentId != null) {
  listenPickupStatus(parentId);
}


}
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseBody = e.response?.data;
      state = state.copyWith(
        loading: false,
        children: [],
        error: 'Request failed ($statusCode): $responseBody',
      );
    } catch (e) {
      state = state.copyWith(loading: false, children: [], error: e.toString());
    }
  }

  void setNoUserState() {
    state = state.copyWith(loading: false, error: 'No user id', children: []);
  }

  void setSelectedSchoolFromLoginResponse(Map<String, dynamic>? loginResponse) {
    if (loginResponse == null) return;

    final schoolRaw = loginResponse['school'];
    if (schoolRaw is! Map<String, dynamic>) return;

    final schoolJson = Map<String, dynamic>.from(schoolRaw);
    if (schoolJson['geofence'] == null && schoolJson['geofense'] != null) {
      schoolJson['geofence'] = schoolJson['geofense'];
    }

    try {
      // print(schoolJson);
      final school = School.fromJson(schoolJson);
      ref.read(selectedSchoolProvider.notifier).state = school;
    } catch (_) {
      ref.read(selectedSchoolProvider.notifier).state = null;
    }
  }

  void pickupStatusChanged(Map<String, dynamic> json) {
  final updatedRequest = PickupRequest.fromJson(json);

  final requests = [...state.pickupRequests];

  final index = requests.indexWhere(
    (e) => e.id == updatedRequest.id,
  );

  if (index != -1) {
    requests[index] = updatedRequest;

    state = state.copyWith(
      pickupRequests: requests,
    );
  }
}

  Future<void> notifyPickup(
    Student child,
    List<PickupRequest> pickupRequests,
  ) async {
    try {
      final student = await ref
          .read(adminServiceProvider)
          .loadStudentById(int.parse(child.id.toString()));
      if (pickupRequests.isNotEmpty) {
        final request = pickupRequests.cast<PickupRequest?>().firstWhere(
          (pick) => pick?.studentId.toString() == child.id.toString(),
          orElse: () => null,
        );

        child.pickupStatus = request?.status;
        // child.pickUpToday = request;
      }
      if (child.pickupStatus == PickupStatus.ChildReleased) {
        final request = pickupRequests.firstWhere(
          (pick) => pick.studentId.toString() == child.id.toString(),
          orElse: () => null as PickupRequest,
        );
        await ref
            .read(pickupServiceProvider)
            .updatePickupStatus(request.id!, PickupStatus.Completed.name);
      } else {
        await ref.read(pickupServiceProvider).createPickupRequest(student);
      }

      await loadData(int.parse(child.schoolId.toString()));
    } catch (e) {
      debugPrint('notifyPickup error: $e');
    }
  }

void listenBusLocation(int busId) {
  print('LISTENING TO BUS => $busId');

  _socket.connect(
    busId: busId,
    onLocation: (lat, lng) {
      print('LOCATION RECEIVED => $lat , $lng');

      state = state.copyWith(
        busLat: lat,
        busLng: lng,
      );
    },
  );
}
  void listenPickupStatus(int parentId) {
  _socket.subscribePickupStatus(
    parentId: parentId,
    onPickup: (json) {
      pickupStatusChanged(json);
    },
  );
}
@override
void dispose() {
  _socket.dispose();
  super.dispose();
}
}
