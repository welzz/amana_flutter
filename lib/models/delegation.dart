enum DelegationStatus {
  active,
  used,
  expired,
  cancelled,
}

DelegationStatus delegationStatusFromString(String status) {
  switch (status) {
    case 'active':
      return DelegationStatus.active;
    case 'used':
      return DelegationStatus.used;
    case 'expired':
      return DelegationStatus.expired;
    case 'cancelled':
      return DelegationStatus.cancelled;
    default:
      throw Exception('Unknown DelegationStatus: $status');
  }
}

String delegationStatusToString(DelegationStatus status) {
  return status.name;
}

class Delegation {
  final int? id;
  final int studentId;
  final String? studentName;
  final int? parentId;
  final String? parentName;
  final String delegateName;
  final String delegatePhone;
  final String token;
  final String pinCode;
  final DateTime startTime;
  final DateTime endTime;
  final int maxUsage;
  final int usageCount;
  final DelegationStatus status;
  final DateTime createdAt;
  final DateTime? usedAt;
  final String? studentPictureUrl;

  Delegation({
    this.id,
    required this.studentId,
    this.studentName,
    this.parentId,
    this.parentName,
    required this.delegateName,
    required this.delegatePhone,
    required this.token,
    required this.pinCode,
    required this.startTime,
    required this.endTime,
    required this.maxUsage,
    required this.usageCount,
    required this.status,
    required this.createdAt,
    this.usedAt,
    this.studentPictureUrl,
  });

  factory Delegation.fromJson(Map<String, dynamic> json) {
    return Delegation(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      parentId: json['parentId'],
      parentName: json['parentName'],
      delegateName: json['delegateName'],
      delegatePhone: json['delegatePhone'],
      token: json['token'],
      pinCode: json['pinCode'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxUsage: json['maxUsage'],
      usageCount: json['usageCount'],
      status: delegationStatusFromString(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'])
          : null,
      studentPictureUrl: json['studentPictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'parentId': parentId,
      'parentName': parentName,
      'delegateName': delegateName,
      'delegatePhone': delegatePhone,
      'token': token,
      'pinCode': pinCode,
      'startTime': startTime.toLocal().toIso8601String(),
      'endTime': endTime.toLocal().toIso8601String(),
      'maxUsage': maxUsage,
      'usageCount': usageCount,
      'status': delegationStatusToString(status),
      'createdAt': createdAt.toLocal().toIso8601String(),
      'usedAt': usedAt?.toLocal().toIso8601String(),
      'studentPictureUrl': studentPictureUrl,
    };
  }
}