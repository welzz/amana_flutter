import 'package:amana_flutter/models/PickupRequest.dart';

import 'user.dart';

class Student {
  final int id;
  final String name;
  final int classId;
  final int parentId;
  final String? pictureUrl;
  final String createdBy;
  final String createdIn;
  final String parentName;
  final String classroom;
  final String? classroomEn;
  final int schoolId;
  final User? user;
  final String nameEn;
  final String? busId;
  final bool? disableIamButtonHere;
  PickupStatus? pickupStatus;

  Student({
    required this.id,
    required this.name,
    required this.classId,
    required this.parentId,
    this.pictureUrl,
    required this.createdBy,
    required this.createdIn,
    required this.parentName,
    required this.classroom,
    this.classroomEn,
    required this.schoolId,
    this.user,
    required this.nameEn,
    this.busId,
    this.disableIamButtonHere,
    this.pickupStatus,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      classId: json['classId'] ?? '',
      parentId: json['parentId'] ?? '',
      pictureUrl: json['pictureUrl']?.toString(),
      createdBy: json['createdBy']?.toString() ?? '',
      createdIn: json['createdIn']?.toString() ?? '',
      parentName: json['parentName']?.toString() ?? '',
      classroom: json['classroom']?.toString() ?? '',
      classroomEn: json['classroomEn']?.toString(),
      schoolId: json['schoolId'] ?? '',
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'])
          : null,
      nameEn: json['nameEn']?.toString() ?? '',
      busId: json['busId']?.toString(),
      disableIamButtonHere: json['disableIamButtonHere'],
      pickupStatus: json['pickupStatus'] != null
          ? PickupStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['pickupStatus'],
              orElse: () => PickupStatus.Awaiting,
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classId': classId,
      'parentId': parentId,
      'pictureUrl': pictureUrl,
      'createdBy': createdBy,
      'createdIn': createdIn,
      'parentName': parentName,
      'classroom': classroom,
      'classroomEn': classroomEn,
      'schoolId': schoolId,
      'user': user?.toJson(),
      'nameEn': nameEn,
      'busId': busId,
      'disableIamButtonHere': disableIamButtonHere,
      'pickupStatus': pickupStatus,
    };
  }

Student copyWith({
  PickupStatus? pickupStatus,
  bool? disableIamButtonHere,
}) {
  return Student(
    id: id,
    name: name,
    classId: classId,
    parentId: parentId,
    pictureUrl: pictureUrl,
    createdBy: createdBy,
    createdIn: createdIn,
    parentName: parentName,
    classroom: classroom,
    classroomEn: classroomEn,
    schoolId: schoolId,
    user: user,
    nameEn: nameEn,
    busId: busId,
    disableIamButtonHere:
        disableIamButtonHere ?? this.disableIamButtonHere,
    pickupStatus: pickupStatus ?? this.pickupStatus,
  );
}
  @override
  String toString() {
    return '''
Student(
  id: $id,
      name: $name,
      classId: $classId,
      parentId: $parentId,
      pictureUrl: $pictureUrl,
      createdBy: $createdBy,
      createdIn: $createdIn,
      parentName: $parentName,
      classroom: $classroom,
      classroomEn: $classroomEn,
      schoolId: $schoolId,
      user: $user?.toJson(),
      nameEn: $nameEn,
      busId: $busId,
      disableIamButtonHere:$disableIamButtonHere,
            pickupStatus:$pickupStatus,

)
''';
  }
}
