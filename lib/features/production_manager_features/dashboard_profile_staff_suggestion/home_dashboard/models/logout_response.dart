// lib/models/logout_response.dart
class LogoutResponse {
  final String message;
  final String username;
  final DateTime timestamp;
  final bool tokenInvalidated;

  LogoutResponse({
    required this.message,
    required this.username,
    required this.timestamp,
    required this.tokenInvalidated,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String,
      username: json['username'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tokenInvalidated: json['token_invalidated'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'username': username,
      'timestamp': timestamp.toIso8601String(),
      'token_invalidated': tokenInvalidated,
    };
  }
}
