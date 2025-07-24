// models/fcm_token_model.dart

class FCMTokenModel {
  final String agentId;
  final String fcmToken;

  FCMTokenModel({required this.agentId, required this.fcmToken});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'agentId': agentId, 'fcmToken': fcmToken};
  }

  // Create from JSON (useful if your API returns data)
  factory FCMTokenModel.fromJson(Map<String, dynamic> json) {
    return FCMTokenModel(agentId: json['agentId'], fcmToken: json['fcmToken']);
  }
}
