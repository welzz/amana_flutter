import 'school.dart';

enum UserRole {
  parent,
  staff,
  admin,
  schooladmin,
  bus,
  schoolsmanager,
}

UserRole userRoleFromString(String role) {
  switch (role) {
    case 'parent':
      return UserRole.parent;
    case 'staff':
      return UserRole.staff;
    case 'admin':
      return UserRole.admin;
    case 'schooladmin':
      return UserRole.schooladmin;
    case 'bus':
      return UserRole.bus;
    case 'schoolsmanager':
      return UserRole.schoolsmanager;
    default:
      throw Exception('Unknown role: $role');
  }
}

String userRoleToString(UserRole role) {
  return role.name;
}

class Child {
  final String id;
  final String name;
  final String className;
  final String classroomEn;
  final String? pictureUrl;
  final String? schoolName;
  final String? schoolNameEn;
  final String? schoolId;
  final String classId;
  final String parentId;

  Child({
    required this.id,
    required this.name,
    required this.className,
    required this.classroomEn,
    this.pictureUrl,
    this.schoolName,
    this.schoolNameEn,
    this.schoolId,
    required this.classId,
    required this.parentId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      className: json['className'],
      classroomEn: json['classroomEn'],
      pictureUrl: json['pictureUrl'],
      schoolName: json['schoolName'],
      schoolNameEn: json['schoolNameEn'],
      schoolId: json['schoolId'],
      classId: json['classId'],
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'classroomEn': classroomEn,
      'pictureUrl': pictureUrl,
      'schoolName': schoolName,
      'schoolNameEn': schoolNameEn,
      'schoolId': schoolId,
      'classId': classId,
      'parentId': parentId,
    };
  }
}

class User {
  final String id;
  final String name;
  final String username;
  final String firstNameEn;
  final UserRole role;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final List<Child>? children;
  final String? schoolId;
  final String? schoolName;
  final School? school;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.firstNameEn,
    required this.role,
    this.password,
    this.email,
    this.phoneNumber,
    this.address,
    this.children,
    this.schoolId,
    this.schoolName,
    this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      firstNameEn: json['firstNameEn'],
      role: userRoleFromString(json['role']),
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      children: json['children'] != null
          ? (json['children'] as List)
              .map((e) => Child.fromJson(e))
              .toList()
          : null,
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      school: json['school'] != null
          ? School.fromJson(json['school'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'firstNameEn': firstNameEn,
      'role': userRoleToString(role),
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'children': children?.map((e) => e.toJson()).toList(),
      'schoolId': schoolId,
      'schoolName': schoolName,
      'school': school?.toJson(),
    };
  }
}