// models/upload_selfie_response.dart

class UploadSelfieResponse {
  final bool status;
  final String message;
  final String? imageUrl;

  UploadSelfieResponse({
    required this.status,
    required this.message,
    this.imageUrl,
  });

  factory UploadSelfieResponse.fromJson(Map<String, dynamic> json) {
    return UploadSelfieResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
