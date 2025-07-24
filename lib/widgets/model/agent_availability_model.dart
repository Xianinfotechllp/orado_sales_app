class AgentAvailabileModel {
  String? message;
  Agent? agent;

  AgentAvailabileModel({this.message, this.agent});
}

class Agent {
  PayoutDetails? payoutDetails;
  Dashboard? dashboard;
  Points? points;
  DeliveryStatus? deliveryStatus;
  Location? location;
  LeaveStatus? leaveStatus;
  Attendance? attendance;
  AgentApplicationDocuments? agentApplicationDocuments;
  Feedback? feedback;
  Permissions? permissions;
  CodTracking? codTracking;
  AgentStatus? agentStatus;
  String? id;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? profilePicture;
  bool? bankDetailsProvided;
  String? applicationStatus;
  String? role;
  String? activityStatus;
  dynamic lastAssignedAt;
  List<dynamic>? incentivePlans;
  List<dynamic>? permissionRequests;
  List<dynamic>? cashDropLogs;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Agent({
    this.payoutDetails,
    this.dashboard,
    this.points,
    this.deliveryStatus,
    this.location,
    this.leaveStatus,
    this.attendance,
    this.agentApplicationDocuments,
    this.feedback,
    this.permissions,
    this.codTracking,
    this.agentStatus,
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.profilePicture,
    this.bankDetailsProvided,
    this.applicationStatus,
    this.role,
    this.activityStatus,
    this.lastAssignedAt,
    this.incentivePlans,
    this.permissionRequests,
    this.cashDropLogs,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
}

class AgentApplicationDocuments {
  String? insurance;
  String? rcBook;
  String? pollutionCertificate;
  DateTime? submittedAt;

  AgentApplicationDocuments({
    this.insurance,
    this.rcBook,
    this.pollutionCertificate,
    this.submittedAt,
  });
}

class AgentStatus {
  String? status;
  String? availabilityStatus;

  AgentStatus({this.status, this.availabilityStatus});
}

class Attendance {
  int? daysWorked;
  int? daysOff;
  List<dynamic>? attendanceLogs;

  Attendance({this.daysWorked, this.daysOff, this.attendanceLogs});
}

class CodTracking {
  int? currentCodHolding;
  int? dailyCollected;
  DateTime? lastUpdated;

  CodTracking({this.currentCodHolding, this.dailyCollected, this.lastUpdated});
}

class Dashboard {
  int? totalDeliveries;
  int? totalCollections;
  int? totalEarnings;
  int? tips;
  int? surge;
  int? incentives;

  Dashboard({
    this.totalDeliveries,
    this.totalCollections,
    this.totalEarnings,
    this.tips,
    this.surge,
    this.incentives,
  });
}

class DeliveryStatus {
  List<dynamic>? currentOrderId;
  String? status;
  int? currentOrderCount;

  DeliveryStatus({this.currentOrderId, this.status, this.currentOrderCount});
}

class Feedback {
  int? averageRating;
  int? totalReviews;
  List<dynamic>? reviews;

  Feedback({this.averageRating, this.totalReviews, this.reviews});
}

class LeaveStatus {
  bool? leaveApplied;
  String? status;

  LeaveStatus({this.leaveApplied, this.status});
}

class Location {
  String? type;
  List<double>? coordinates;
  int? accuracy;

  Location({this.type, this.coordinates, this.accuracy});
}

class PayoutDetails {
  int? totalEarnings;
  int? tips;
  int? surge;
  int? incentives;
  int? totalPaid;
  int? pendingPayout;

  PayoutDetails({
    this.totalEarnings,
    this.tips,
    this.surge,
    this.incentives,
    this.totalPaid,
    this.pendingPayout,
  });
}

class Permissions {
  bool? canAcceptOrRejectOrders;
  int? maxActiveOrders;
  int? maxCodAmount;
  bool? canChangeMaxActiveOrders;
  bool? canChangeCodAmount;

  Permissions({
    this.canAcceptOrRejectOrders,
    this.maxActiveOrders,
    this.maxCodAmount,
    this.canChangeMaxActiveOrders,
    this.canChangeCodAmount,
  });
}

class Points {
  int? totalPoints;

  Points({this.totalPoints});
}
