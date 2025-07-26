class SelfieStatusModel {
  final bool selfieRequired;
  final String message;

  SelfieStatusModel({required this.selfieRequired, required this.message});

  factory SelfieStatusModel.fromJson(Map<String, dynamic> json) {
    return SelfieStatusModel(
      selfieRequired: json['selfieRequired'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
