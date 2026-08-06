import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/school.dart';
import '../../models/classroom.dart';
import '../../models/student.dart';
import '../../models/user.dart';
import '../../models/bus.dart';
import '../../models/schoolmanager.dart';

class AdminService {
  final String baseUrl;

  AdminService({required this.baseUrl});

  /// ======================
  /// MAIL
  /// ======================

  Future<void> resetMail(String username) async {
    await http.post(
      Uri.parse('$baseUrl/api/mail/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
  }

  Future<void> resetPassword(String token, String password) async {
    await http.post(
      Uri.parse('$baseUrl/api/mail/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': password}),
    );
  }

  /// ======================
  /// SCHOOLS MANAGERS
  /// ======================

  Future<List<SchoolsManagers>> loadSchoolsManagers() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/schoolsManagers/loadAllSchoolsManagers'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => SchoolsManagers.fromJson(e)).toList();
  }

  Future<List<SchoolsManagers>> loadSchoolsManagersByUserId(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/schoolsManagers/loadAllSchoolsManagersByUserId/$userId'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => SchoolsManagers.fromJson(e)).toList();
  }

  /// ======================
  /// BUSES
  /// ======================

  Future<Bus> addBus(
    String schoolId,
    String busNumber,
    String driverId,
    List<String> studentIds,
  ) async {
    final payload = {
      "id": "",
      "schoolId": schoolId,
      "busNumber": busNumber,
      "driverId": driverId,
      "studentIds": studentIds,
    };

    final res = await http.post(
      Uri.parse('$baseUrl/api/bus/saveBus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    return Bus.fromJson(jsonDecode(res.body));
  }

  Future<List<Bus>> loadBuses() async {
    final res = await http.get(Uri.parse('$baseUrl/api/bus/loadAllBuses'));
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Bus.fromJson(e)).toList();
  }

  Future<Bus> updateBus(Bus bus) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/bus/BusUpdate/${bus.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bus.toJson()),
    );

    return Bus.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteBus(int id) async {
    await http.delete(Uri.parse('$baseUrl/api/bus/deleteBus/$id'));
  }

  /// ======================
  /// CLASSROOMS
  /// ======================

  Future<Classroom> saveClassroom(Classroom classroom) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/classroom/saveNewClassroom'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(classroom.toJson()),
    );

    return Classroom.fromJson(jsonDecode(res.body));
  }

  Future<List<Classroom>> loadClassrooms() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/classroom/loadAllClassRoom'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Classroom.fromJson(e)).toList();
  }

  Future<List<Classroom>> loadClassroomsBySchoolId(int schoolId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/classroom/loadClassroomsBySchoolId/$schoolId'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Classroom.fromJson(e)).toList();
  }

  Future<void> deleteClassroom(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/api/classroom/deleteClassroom/$id'),
    );
  }

  /// ======================
  /// SCHOOLS
  /// ======================

  Future<School> saveSchool(School school) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/schools/saveNewSchool'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );

    return School.fromJson(jsonDecode(res.body));
  }

  Future<List<School>> loadSchools() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/schools/loadAllSchools'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => School.fromJson(e)).toList();
  }

  Future<void> deleteSchool(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/api/schools/deleteSchool/$id'),
    );
  }

  /// ======================
  /// USERS
  /// ======================

  Future<User> saveUser(User user) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/admin/saveNewUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return User.fromJson(jsonDecode(res.body));
  }

  Future<List<User>> loadUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/api/admin/users'));

    final data = jsonDecode(res.body) as List;
    return data.map((e) => User.fromJson(e)).toList();
  }

  Future<User> loadUserById(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/admin/loadUserById/$id'),
    );

    return User.fromJson(jsonDecode(res.body));
  }

  /// ======================
  /// STUDENTS
  /// ======================

  Future<Student> saveStudent(Student student) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/students/saveNewStudent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );

    return Student.fromJson(jsonDecode(res.body));
  }

  Future<List<Student>> loadStudents() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/students/loadAllStudents'),
    );

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Student.fromJson(e)).toList();
  }

  Future<Student> loadStudentById(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/students/loadStudentById/$id'),
    );

    return Student.fromJson(jsonDecode(res.body));
  }
}