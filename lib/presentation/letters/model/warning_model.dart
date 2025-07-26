class WarningModel {
  final String reason;
  final String issuedBy;
  final String id;
  final DateTime issuedAt;

  WarningModel({
    required this.reason,
    required this.issuedBy,
    required this.id,
    required this.issuedAt,
  });

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      reason: json['reason'],
      issuedBy: json['issuedBy'],
      id: json['_id'],
      issuedAt: DateTime.parse(json['issuedAt']),
    );
  }
}
