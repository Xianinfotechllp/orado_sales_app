class EarningsSummaryModel {
  final String period;
  final String agentId;
  final Summary summary;
  final DeliveryStats deliveryStats;

  EarningsSummaryModel({
    required this.period,
    required this.agentId,
    required this.summary,
    required this.deliveryStats,
  });

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryModel(
      period: json['period'],
      agentId: json['agentId'],
      summary: Summary.fromJson(json['summary']),
      deliveryStats: DeliveryStats.fromJson(json['deliveryStats']),
    );
  }
}

class Summary {
  final int totalEarnings;
  final int baseEarnings;
  final int tips;
  final int surgeBonus;
  final int incentives;
  final int penalties;
  final int other;

  Summary({
    required this.totalEarnings,
    required this.baseEarnings,
    required this.tips,
    required this.surgeBonus,
    required this.incentives,
    required this.penalties,
    required this.other,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalEarnings: json['totalEarnings'],
    baseEarnings: json['baseEarnings'],
    tips: json['tips'],
    surgeBonus: json['surgeBonus'],
    incentives: json['incentives'],
    penalties: json['penalties'],
    other: json['other'],
  );
}

class DeliveryStats {
  final int totalDeliveries;
  final int completedDeliveries;

  DeliveryStats({
    required this.totalDeliveries,
    required this.completedDeliveries,
  });

  factory DeliveryStats.fromJson(Map<String, dynamic> json) => DeliveryStats(
    totalDeliveries: json['totalDeliveries'],
    completedDeliveries: json['completedDeliveries'],
  );
}
