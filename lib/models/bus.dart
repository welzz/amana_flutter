import 'student.dart';

class Bus {
  final int id;
  final int schoolId;
  final int busNumber;
  final int driverId;
  final List<int> studentIds;
  final List<Student> students;

  Bus({
    required this.id,
    required this.schoolId,
    required this.busNumber,
    required this.driverId,
    required this.studentIds,
    required this.students,
  });
factory Bus.fromJson(Map<String, dynamic> json) {
  return Bus(
    id: json['id'] ?? 0,
    schoolId: json['schoolId'] ?? 0,
    busNumber: json['busNumber'] ?? 0,
    driverId: json['driverId'] ?? 0,

    studentIds: (json['studentIds'] as List?)
            ?.map((e) => e as int)
            .toList() ??
        [],

    students: (json['students'] as List?)
            ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'busNumber': busNumber,
      'driverId': driverId,
      'studentIds': studentIds,
      'students': students?.map((e) => e.toJson()).toList(),
    };
  }
}