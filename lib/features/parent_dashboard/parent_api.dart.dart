import 'package:dio/dio.dart';

class ParentApi {
  final Dio dio;

  ParentApi(this.dio);

  /// 📌 Load children for parent
Future<List<dynamic>> getPickupBySchoolIdToday(int schoolId) async {
  final res = await dio.get("/PickupRequest/loadPickupStudentBySchoolidToday/$schoolId");
  return res.data;
}

  /// 📌 Load pickup requests today
  Future<List<dynamic>> getTodayPickupRequests(int schoolId) async {
    final res = await dio.get("/pickup/school/$schoolId/today");
    return res.data;
  }

  /// 📌 Create pickup request
  Future<void> createPickupRequest({
    required int parentId,
    required int studentId,
  }) async {
    await dio.post("/pickup/create", data: {
      "parentId": parentId,
      "studentId": studentId,
    });
  }

  /// 📌 Update pickup status
  Future<void> updatePickupStatus(int requestId, String status) async {
    await dio.put("/pickup/$requestId/status", data: {
      "status": status,
    });
  }

  /// 📌 Load student by id
  Future<dynamic> getStudentById(int id) async {
    final res = await dio.get("/students/$id");
    return res.data;
  }

  /// 📌 Support ticket
  Future<void> createTicket({
    required int userId,
    required String subject,
    required String message,
  }) async {
    await dio.post("/support/ticket", data: {
      "userId": userId,
      "subject": subject,
      "message": message,
    });
  }
  Future<Map<String,dynamic>> getBusLocation(
    int busId) async {

  final res = await dio.get(
   
      'bus/loadBusById/$busId',
     
  );

  return (res.data);
}
}