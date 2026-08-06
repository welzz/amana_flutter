class SchoolsManagers {
  final int id;
  final int schoolId;
  final int userId;

  SchoolsManagers({
    required this.id,
    required this.schoolId,
    required this.userId,
  });

  factory SchoolsManagers.fromJson(Map<String, dynamic> json) {
    return SchoolsManagers(
      id: json['id'],
      schoolId: json['schoolId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'userId': userId,
    };
  }
}