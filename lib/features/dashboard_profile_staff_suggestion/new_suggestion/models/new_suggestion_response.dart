// lib/features/dashboard_profile_staff_suggestion/models/new_suggestion_response.dart
class NewSuggestionResponse {
  final String name;

  NewSuggestionResponse({required this.name});

  factory NewSuggestionResponse.fromJson(Map<String, dynamic> json) {
    return NewSuggestionResponse(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
