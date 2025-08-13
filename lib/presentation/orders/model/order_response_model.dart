// order_response_model.dart
class OrderResponseModel {
  final bool success;
  final String message;

  OrderResponseModel({required this.success, required this.message});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown response',
    );
  }
}
