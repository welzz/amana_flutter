import 'user.dart';

enum TicketStatus {
  Open,
  InProgress,
  Closed,
}

TicketStatus ticketStatusFromString(String status) {
  switch (status) {
    case 'Open':
      return TicketStatus.Open;
    case 'InProgress':
      return TicketStatus.InProgress;
    case 'Closed':
      return TicketStatus.Closed;
    default:
      throw Exception('Unknown TicketStatus: $status');
  }
}

String ticketStatusToString(TicketStatus status) {
  return status.name;
}

class SupportTicket {
  final String id;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String subject;
  final String message;
  final DateTime createdAt;
  final TicketStatus status;
  final String? solution;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.status,
    this.solution,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userRole: userRoleFromString(json['userRole']),
      subject: json['subject'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      status: ticketStatusFromString(json['status']),
      solution: json['solution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userRole': userRoleToString(userRole),
      'subject': subject,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': ticketStatusToString(status),
      'solution': solution,
    };
  }
}