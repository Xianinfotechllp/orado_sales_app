class Agent {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    // FIX: Use null-aware operator (??) to provide default empty strings
    // if the JSON keys are missing or their values are null.
    // Replace 'unknown' or 'N/A' with empty strings if that's more appropriate for your UI.
    return Agent(
      id:
          json['_id']?.toString() ??
          '', // Ensure it's a string, provide empty if null
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['agentApplicationStatus']?.toString() ?? '',
    );
  }
}
