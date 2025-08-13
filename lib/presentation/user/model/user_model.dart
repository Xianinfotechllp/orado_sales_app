class AgentProfile {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String profilePicture;
  final Dashboard dashboard;
  final Points points;
  final bool bankDetailsProvided;
  final PayoutDetails payoutDetails;
  final String? qrCode;
  final String role;
  final AgentStatus agentStatus;
  final Attendance attendance;
  final Feedback feedback;
  final Documents documents;
  final Permissions permissions;
  final CodTracking codTracking;

  AgentProfile({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.dashboard,
    required this.points,
    required this.bankDetailsProvided,
    required this.payoutDetails,
    this.qrCode,
    required this.role,
    required this.agentStatus,
    required this.attendance,
    required this.feedback,
    required this.documents,
    required this.permissions,
    required this.codTracking,
  });

  factory AgentProfile.fromJson(Map<String, dynamic> json) {
    return AgentProfile(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      dashboard: Dashboard.fromJson(json['dashboard'] ?? {}),
      points: Points.fromJson(json['points'] ?? {}),
      bankDetailsProvided: json['bankDetailsProvided'] ?? false,
      payoutDetails: PayoutDetails.fromJson(json['payoutDetails'] ?? {}),
      qrCode: json['qrCode'],
      role: json['role'] ?? '',
      agentStatus: AgentStatus.fromJson(json['agentStatus'] ?? {}),
      attendance: Attendance.fromJson(json['attendance'] ?? {}),
      feedback: Feedback.fromJson(json['feedback'] ?? {}),
      documents: Documents.fromJson(json['documents'] ?? {}),
      permissions: Permissions.fromJson(json['permissions'] ?? {}),
      codTracking: CodTracking.fromJson(json['codTracking'] ?? {}),
    );
  }
}

class Dashboard {
  final int totalDeliveries;
  final int totalCollections;
  final int totalEarnings;
  final int tips;
  final int surge;
  final int incentives;

  Dashboard({
    required this.totalDeliveries,
    required this.totalCollections,
    required this.totalEarnings,
    required this.tips,
    required this.surge,
    required this.incentives,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalDeliveries: json['totalDeliveries'] ?? 0,
      totalCollections: json['totalCollections'] ?? 0,
      totalEarnings: json['totalEarnings'] ?? 0,
      tips: json['tips'] ?? 0,
      surge: json['surge'] ?? 0,
      incentives: json['incentives'] ?? 0,
    );
  }
}

class Points {
  final int totalPoints;

  Points({required this.totalPoints});

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(totalPoints: json['totalPoints'] ?? 0);
  }
}

class PayoutDetails {
  final int totalEarnings;
  final int tips;
  final int surge;
  final int incentives;
  final int totalPaid;
  final int pendingPayout;

  PayoutDetails({
    required this.totalEarnings,
    required this.tips,
    required this.surge,
    required this.incentives,
    required this.totalPaid,
    required this.pendingPayout,
  });

  factory PayoutDetails.fromJson(Map<String, dynamic> json) {
    return PayoutDetails(
      totalEarnings: json['totalEarnings'] ?? 0,
      tips: json['tips'] ?? 0,
      surge: json['surge'] ?? 0,
      incentives: json['incentives'] ?? 0,
      totalPaid: json['totalPaid'] ?? 0,
      pendingPayout: json['pendingPayout'] ?? 0,
    );
  }
}

class AgentStatus {
  final String status;
  final String availabilityStatus;

  AgentStatus({required this.status, required this.availabilityStatus});

  factory AgentStatus.fromJson(Map<String, dynamic> json) {
    return AgentStatus(
      status: json['status'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
    );
  }
}

class Attendance {
  final int daysWorked;
  final int daysOff;

  Attendance({required this.daysWorked, required this.daysOff});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      daysWorked: json['daysWorked'] ?? 0,
      daysOff: json['daysOff'] ?? 0,
    );
  }
}

class Feedback {
  final double averageRating;
  final int totalReviews;

  Feedback({required this.averageRating, required this.totalReviews});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class Documents {
  final String insurance;
  final String rcBook;
  final String pollutionCertificate;
  final DateTime submittedAt;

  Documents({
    required this.insurance,
    required this.rcBook,
    required this.pollutionCertificate,
    required this.submittedAt,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      insurance: json['insurance'] ?? '',
      rcBook: json['rcBook'] ?? '',
      pollutionCertificate: json['pollutionCertificate'] ?? '',
      submittedAt: DateTime.parse(
        json['submittedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Permissions {
  final bool canAcceptOrRejectOrders;
  final int maxActiveOrders;
  final int maxCODAmount;
  final bool canChangeMaxActiveOrders;
  final bool canChangeCODAmount;

  Permissions({
    required this.canAcceptOrRejectOrders,
    required this.maxActiveOrders,
    required this.maxCODAmount,
    required this.canChangeMaxActiveOrders,
    required this.canChangeCODAmount,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      canAcceptOrRejectOrders: json['canAcceptOrRejectOrders'] ?? false,
      maxActiveOrders: json['maxActiveOrders'] ?? 0,
      maxCODAmount: json['maxCODAmount'] ?? 0,
      canChangeMaxActiveOrders: json['canChangeMaxActiveOrders'] ?? false,
      canChangeCODAmount: json['canChangeCODAmount'] ?? false,
    );
  }
}

class CodTracking {
  final int currentCODHolding;
  final int dailyCollected;
  final DateTime lastUpdated;

  CodTracking({
    required this.currentCODHolding,
    required this.dailyCollected,
    required this.lastUpdated,
  });

  factory CodTracking.fromJson(Map<String, dynamic> json) {
    return CodTracking(
      currentCODHolding: json['currentCODHolding'] ?? 0,
      dailyCollected: json['dailyCollected'] ?? 0,
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
