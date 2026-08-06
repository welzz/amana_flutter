enum SchoolType {
  Government,
  Private,
  International,
}

SchoolType schoolTypeFromString(String type) {
  switch (type) {
    case 'Government':
      return SchoolType.Government;
    case 'Private':
      return SchoolType.Private;
    case 'International':
      return SchoolType.International;
    default:
      throw Exception('Unknown SchoolType: $type');
  }
}

String schoolTypeToString(SchoolType type) {
  return type.name;
}

enum StudentGender {
  Male,
  Female,
  Both,
}

StudentGender studentGenderFromString(String gender) {
  switch (gender) {
    case 'Male':
      return StudentGender.Male;
    case 'Female':
      return StudentGender.Female;
    case 'Both':
      return StudentGender.Both;
    default:
      throw Exception('Unknown StudentGender: $gender');
  }
}

String studentGenderToString(StudentGender gender) {
  return gender.name;
}

class GeofencePoint {
  final double lat;
  final double lon;

  GeofencePoint({
    required this.lat,
    required this.lon,
  });

  factory GeofencePoint.fromJson(Map<String, dynamic> json) {
    return GeofencePoint(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}

class School {
  final String id;
  final String name;
  final List<GeofencePoint> geofence;
  final String country;
  final String state;
  final String city;
  final String description;
  final SchoolType type;
  final StudentGender studentGender;
  final String nameEn;
  final String? schoolsMgrId;
  final double? latitude;
  final double? longitude;

  School({
    required this.id,
    required this.name,
    required this.geofence,
    required this.country,
    required this.state,
    required this.city,
    required this.description,
    required this.type,
    required this.studentGender,
    required this.nameEn,
    this.schoolsMgrId,
    this.latitude,
    this.longitude,
  });

 factory School.fromJson(
  Map<String, dynamic> json,
) {
  return School(
    id: json['id'].toString(),

    name: json['name'] ?? '',

    geofence:
        (json['geofence'] as List<dynamic>? ?? [])
            .map(
              (e) => GeofencePoint.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList(),

    country: json['country'] ?? '',

    state: json['state'] ?? '',

    city: json['city'] ?? '',

    description:
        json['description'] ?? '',

    nameEn: json['nameEn'] ?? '',
     schoolsMgrId:
        json['schoolsMgrId'].toString(),

    latitude:
        (json['latitude'] as num?)
            ?.toDouble(),

    longitude:
        (json['longitude'] as num?)
            ?.toDouble(),

    type: SchoolType.values.firstWhere(
      (e) =>
          e.name.toLowerCase() ==
          json['type']
              .toString()
              .toLowerCase(),
    ),

    studentGender:
        StudentGender.values.firstWhere(
      (e) =>
          e.name.toLowerCase() ==
          json['studentGender']
              .toString()
              .toLowerCase(),
    ),
  );
}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'geofence': geofence.map((e) => e.toJson()).toList(),
      'country': country,
      'state': state,
      'city': city,
      'description': description,
      'type': schoolTypeToString(type),
      'studentGender': studentGenderToString(studentGender),
      'nameEn': nameEn,
      'schoolsMgrId': schoolsMgrId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}