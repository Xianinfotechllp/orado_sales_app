class TerminationModel {
  final bool terminated;
  final DateTime terminatedAt;
  final String issuedBy;
  final String reason;
  final String letter;

  TerminationModel({
    required this.terminated,
    required this.terminatedAt,
    required this.issuedBy,
    required this.reason,
    required this.letter,
  });

  factory TerminationModel.fromJson(Map<String, dynamic> json) {
    return TerminationModel(
      terminated: json['terminated'],
      terminatedAt: DateTime.parse(json['terminatedAt']),
      issuedBy: json['issuedBy'],
      reason: json['reason'],
      letter: json['letter'],
    );
  }
}
