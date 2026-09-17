import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/PickupRequest.dart';
import '../../models/user.dart';
import '../../models/student.dart';
import '../../models/classroom.dart';
import '../../models/school.dart';
import '../../models/bus.dart';

class PickupService {
  final String baseUrl;

  PickupService( {required this.baseUrl});

  /// =========================
  /// GET PICKUPS
  /// =========================

  Future<List<PickupRequest>> loadSPickupRequest(int schoolId) async {
    final res = await http.get(
      Uri.parse(
        '$baseUrl/PickupRequest/loadPickupStudentBySchoolid/$schoolId',
      ),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => PickupRequest.fromJson(e)).toList();
  }

  Future<List<PickupRequest>> loadSPickupRequestToday(int schoolId) async {
    // print(schoolId);
    //     print(baseUrl);

    final res = await http.get(
      Uri.parse(
        '$baseUrl/PickupRequest/loadPickupStudentBySchoolidToday/$schoolId',
      ),
    );
// print('STATUS CODE: ${res.statusCode}');
// print('BODY RAW: ${res.body}');
    final data = jsonDecode(res.body) as List;
      // print(data);
    return data.map((e) => PickupRequest.fromJson(e)).toList();
  }

  Future<List<PickupRequest>> loadSPickupRequestFromNumberOfDays(
    int schoolId,
    int days,
  ) async {
    final uri =
        Uri.parse(
          '$baseUrl/PickupRequest/loadSPickupRequestFromNumberOfDays',
        ).replace(
          queryParameters: {
            'schoolId': schoolId.toString(),
            'days': days.toString(),
          },
        );

    final res = await http.get(uri);

    final data = jsonDecode(res.body) as List;
    return data.map((e) => PickupRequest.fromJson(e)).toList();
  }

  /// =========================
  /// STUDENTS / CLASSROOMS / SCHOOLS (from AdminService)
  /// =========================

  Future<List<Student>> loadStudents() async {
    final res = await http.get(
      Uri.parse('$baseUrl/students/loadAllStudents'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Student.fromJson(e)).toList();
  }

  Future<List<Classroom>> loadClassRooms() async {
    final res = await http.get(
      Uri.parse('$baseUrl/classroom/loadAllClassRoom'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Classroom.fromJson(e)).toList();
  }

  Future<List<School>> loadSchools() async {
    final res = await http.get(
      Uri.parse('$baseUrl/schools/loadAllSchools'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => School.fromJson(e)).toList();
  }

  /// =========================
  /// CREATE BUS PICKUP
  /// =========================

  Future<void> createBusPickupRequest(
    List<Student> studentsPickupBus,
    User driver,
    Bus bus,
  ) async {
    final payload = studentsPickupBus.map((student) {
      return {
        "id": "",
        "parentId": student.parentId,
        "parentName": "",
        "parentNameEn": "",
        "studentId": student.id,
        "studentName": "",
        "studentNameEn": "",
        "studentClass": "",
        "studentClassNameEn": "",
        "studentPictureUrl": "",
        "schoolName": "",
        "schoolNameEn": "",
        "arrivalTime": DateTime.now().toIso8601String(),
        "status": "Awaiting",
        "schooltId": student.schoolId,
        "classroomId": student.classId,
        "buspickup": true,
        "busId": bus.id,
      };
    }).toList();

    await http.post(
      Uri.parse('$baseUrl/api/PickupRequest/savePickUpArrayBus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
  }

  /// =========================
  /// CREATE SINGLE PICKUP
  /// =========================

  Future<PickupRequest> createPickupRequest(Student student) async {
    print(student);
    final newRequest = {
      "id": "",
      "parentId": student.parentId,
      "parentName": "",
      "parentNameEn": "",
      "studentId": student.id,
      "studentName": student.name,
      "studentNameEn": "",
      "studentClass": student.classroom,
      "studentClassNameEn": "",
      "studentPictureUrl": student.pictureUrl,
      "schoolName": "",
      "schoolNameEn": "",
      "arrivalTime": DateTime.now().toIso8601String(),
      "status": "Awaiting",
      "schooltId": student.schoolId,
      "classroomId": student.classId,
      "buspickup": false,
      "busId": null,
      "busNumber": null,
    };

    final res = await http.post(
      Uri.parse('$baseUrl/PickupRequest/saveNewPickUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newRequest),
    );

    // print(res.statusCode);
    // print(res.body);

    if (res.body.isEmpty) {
      throw Exception('Empty response body');
    }

    return PickupRequest.fromJson(jsonDecode(res.body));
  }

  /// =========================
  /// UPDATE STATUS
  /// =========================

  Future<PickupRequest> updatePickupStatus(int requestId, String status) async {
    final res = await http.put(
      Uri.parse(
        '$baseUrl/PickupRequest/updatePickupStatusReleasedChild/$requestId',
      ),
      headers: {'Content-Type': 'application/json'},
      body: status,
    );

    return PickupRequest.fromJson(jsonDecode(res.body));
  }

  /// =========================
  /// SINGLE PICKUP TODAY
  /// =========================

  Future<PickupRequest> loadStudentPickUpTodayById(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/PickupRequest/loadStudentPickUpTodayById/$id'),
    );

    return PickupRequest.fromJson(jsonDecode(res.body));
  }

  /// =========================
  /// FILTER BY SCHOOL IDS
  /// =========================

  Future<List<PickupRequest>> loadPickupBySchoolIds(List<int> schoolIds) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/PickupRequest/loadPickupBySchoolIds'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schoolIds),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => PickupRequest.fromJson(e)).toList();
  }
}
