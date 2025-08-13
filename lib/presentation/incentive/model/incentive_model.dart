class IncentiveSummaryModel {
  final bool incentiveConfigured;
  final String type;
  final String dateLabel;
  final String title;
  final String description;
  final String basedOn;
  final int targetValue;
  final int currentValue;
  final int reward;
  final String rewardType;
  final int percent;
  final int remaining;
  final bool completed;
  final List<dynamic> pastEarnings;

  IncentiveSummaryModel({
    required this.incentiveConfigured,
    required this.type,
    required this.dateLabel,
    required this.title,
    required this.description,
    required this.basedOn,
    required this.targetValue,
    required this.currentValue,
    required this.reward,
    required this.rewardType,
    required this.percent,
    required this.remaining,
    required this.completed,
    required this.pastEarnings,
  });

  factory IncentiveSummaryModel.fromJson(Map<String, dynamic> json) {
    return IncentiveSummaryModel(
      incentiveConfigured: json['incentiveConfigured'] ?? false,
      type: json['type'] ?? '',
      dateLabel: json['dateLabel'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      basedOn: json['basedOn'] ?? '',
      targetValue: json['targetValue'] ?? 0,
      currentValue: json['currentValue'] ?? 0,
      reward: json['reward'] ?? 0,
      rewardType: json['rewardType'] ?? '',
      percent: json['percent'] ?? 0,
      remaining: json['remaining'] ?? 0,
      completed: json['completed'] ?? false,
      pastEarnings: json['pastEarnings'] ?? [],
    );
  }
}
