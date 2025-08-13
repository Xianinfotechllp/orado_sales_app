class LoginAgent {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;
  final String role;
  final String applicationStatus;

  LoginAgent({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
    required this.role,
    required this.applicationStatus,
  });

  factory LoginAgent.fromJson(Map<String, dynamic> json) {
    return LoginAgent(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePicture: json['profilePicture'],
      role: json['role'] ?? '',
      applicationStatus: json['applicationStatus'] ?? '',
    );
  }
}

class LoginResponse {
  final int statusCode;
  final String message;
  final String token;
  final LoginAgent agent;

  LoginResponse({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.agent,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      agent: LoginAgent.fromJson(json['agent'] ?? {}),
    );
  }
}
