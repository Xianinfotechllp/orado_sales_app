// models/leave_model.dart

class LeaveApplication {
  final String leaveStartDate;
  final String leaveEndDate;
  final String leaveType;
  final String reason;
  final String? status;
  final DateTime? appliedAt;
  final String? id;

  LeaveApplication({
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.leaveType,
    required this.reason,
    this.status,
    this.appliedAt,
    this.id,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      leaveStartDate: json['leaveStartDate'],
      leaveEndDate: json['leaveEndDate'],
      leaveType: json['leaveType'],
      reason: json['reason'],
      status: json['status'],
      appliedAt:
          json['appliedAt'] != null ? DateTime.parse(json['appliedAt']) : null,
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveStartDate': leaveStartDate,
      'leaveEndDate': leaveEndDate,
      'leaveType': leaveType,
      'reason': reason,
    };
  }
}

class LeaveStatusResponse {
  final String message;
  final int total;
  final List<LeaveApplication> leaves;

  LeaveStatusResponse({
    required this.message,
    required this.total,
    required this.leaves,
  });

  factory LeaveStatusResponse.fromJson(Map<String, dynamic> json) {
    var leavesList = json['leaves'] as List;
    List<LeaveApplication> leaves =
        leavesList.map((leave) => LeaveApplication.fromJson(leave)).toList();

    return LeaveStatusResponse(
      message: json['message'],
      total: json['total'],
      leaves: leaves,
    );
  }
}
