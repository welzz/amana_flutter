class Classroom {
  final String id;
  final String name;
  final String schoolId;
  final String applicationTypeId;
  final String createdBy;
  final String createdIn;
  final String nameEn;

  Classroom({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.applicationTypeId,
    required this.createdBy,
    required this.createdIn,
    required this.nameEn,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      schoolId: json['schoolId'],
      applicationTypeId: json['applicationTypeId'],
      createdBy: json['createdBy'],
      createdIn: json['createdIn'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'schoolId': schoolId,
      'applicationTypeId': applicationTypeId,
      'createdBy': createdBy,
      'createdIn': createdIn,
      'nameEn': nameEn,
    };
  }
}