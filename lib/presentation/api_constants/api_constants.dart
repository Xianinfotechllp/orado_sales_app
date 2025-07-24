class ApiConstants {
  static const String baseUrl = 'https://orado-backend.onrender.com';
  static const String socketUrl = 'https://orado-backend.onrender.com';

  static String registerAgent() => '$baseUrl/agent/register';
  static String loginAgent() => '$baseUrl/agent/login';
  static String updateAvailability(String agentId) =>
      '$baseUrl/agent/$agentId/availability';
  static String deviceInfo() => '$baseUrl/agent/device-info';
  static String socketApi() => socketUrl;
}
