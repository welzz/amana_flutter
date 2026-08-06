import 'dart:convert';

import 'package:amana_flutter/core/config/app_config.dart';
import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:amana_flutter/models/bus.dart';
import 'package:amana_flutter/models/student.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final busRepositoryProvider = Provider<BusRepository>((ref) {
  return BusRepository(
    baseUrl: AppConfig.baseUrl,
  );
});
class BusRepository {
    final String baseUrl;

BusRepository({required this.baseUrl});
Future<List<Bus>> loadBusByUserId(int userId) async {
  final url = '$baseUrl/bus/loadBusByUserId/$userId';

  final res = await http.get(Uri.parse(url));

  // print(res.body);

  final data = jsonDecode(res.body);

  // لو API بيرجع Bus واحد
  final bus = Bus.fromJson(data);

  return [bus];
}

  Future<void> sendStudents(
    List<Student> students, Bus? bus,
  ) async {
 final payload = students.map((student) {
    return PickupRequest(
     
      parentId: student.parentId,
      parentName: '',
      parentNameEn: '',
      studentId: student.id,
      studentName: '',
      studentNameEn: '',
      studentClass: '',
      studentClassNameEn: '',
      studentPictureUrl: '',
      schoolName: '',
      schoolNameEn: '',
      arrivalTime: DateTime.now(),
      status: PickupStatus.Awaiting,
      schooltId: student.schoolId,
      classroomId: student.classId,
      buspickup: true,
      busId: bus?.id,
    );
  }).toList();
     await http.post(
      Uri.parse('$baseUrl/PickupRequest/savePickUpArrayBus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

 
  }

 Future<void> updateBusLocation(
  int busId,
  double lat,
  double lng,
) async {
  await http.post(
    Uri.parse(
      '$baseUrl/bus/updateLocation',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'busId': busId,
      'latitude': lat,
      'longitude': lng,
      'lastUpdate': DateTime.now().toIso8601String(),
    }),
  );
}
}