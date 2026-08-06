enum PickupStatus {
  Awaiting,
  ChildReleased,
  Completed,
}

PickupStatus pickupStatusFromString(String status) {
  switch (status) {
    case 'Awaiting':
      return PickupStatus.Awaiting;
    case 'ChildReleased':
      return PickupStatus.ChildReleased;
    case 'Completed':
      return PickupStatus.Completed;
    default:
      throw Exception('Unknown PickupStatus: $status');
  }
}

String pickupStatusToString(PickupStatus status) {
  return status.name;
}

class PickupRequest {
  final int? id;
  final int parentId;
  final String parentName;
  final String parentNameEn;
  final int studentId;
  final String studentName;
  final String studentNameEn;
  final String studentClass;
  final String studentClassNameEn;
  final String? studentPictureUrl;
  final String schoolName;
  final String schoolNameEn;
  final DateTime arrivalTime;
  final PickupStatus status;
  final int schooltId;
  final int classroomId;
  final bool buspickup;
  final int? busId;
  final String? busNumber;

  PickupRequest({
      this.id,
    required this.parentId,
    required this.parentName,
    required this.parentNameEn,
    required this.studentId,
    required this.studentName,
    required this.studentNameEn,
    required this.studentClass,
    required this.studentClassNameEn,
    this.studentPictureUrl,
    required this.schoolName,
    required this.schoolNameEn,
    required this.arrivalTime,
    required this.status,
    required this.schooltId,
    required this.classroomId,
    required this.buspickup,
    this.busId,
    this.busNumber,
  });

 factory PickupRequest.fromJson(Map<String, dynamic> json) {
    return PickupRequest(
      id: json['id'] ?? 0,
      parentId: json['parentId'] ?? 0,
      parentName: json['parentName'] ?? '',
      parentNameEn: json['parentNameEn'] ?? '',
      studentId: json['studentId'] ?? 0,
      studentName: json['studentName'] ?? '',
      studentNameEn: json['studentNameEn'] ?? '',
      studentClass: json['studentClass'] ?? '',
      studentClassNameEn: json['studentClassNameEn'] ?? '',
      studentPictureUrl: json['studentPictureUrl'],
      schoolName: json['schoolName'] ?? '',
      schoolNameEn: json['schoolNameEn'] ?? '',
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? '') ?? DateTime.now(),
      status: pickupStatusFromString(
        (json['status'] ?? 'Awaiting').toString(),
      ),
      schooltId: json['schooltId'] ?? 0,
      classroomId: json['classroomId'] ?? 0,
      buspickup: json['buspickup'] ?? false,
      busId: json['busId'],
      busNumber: json['busNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'parentName': parentName,
      'parentNameEn': parentNameEn,
      'studentId': studentId,
      'studentName': studentName,
      'studentNameEn': studentNameEn,
      'studentClass': studentClass,
      'studentClassNameEn': studentClassNameEn,
      'studentPictureUrl': studentPictureUrl,
      'schoolName': schoolName,
      'schoolNameEn': schoolNameEn,
      'arrivalTime': arrivalTime.toIso8601String(),
      'status': pickupStatusToString(status),
      'schooltId': schooltId,
      'classroomId': classroomId,
      'buspickup': buspickup,
      'busId': busId,
      'busNumber': busNumber,
    };
  }
}