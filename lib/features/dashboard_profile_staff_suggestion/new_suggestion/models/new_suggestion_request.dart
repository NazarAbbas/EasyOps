// lib/features/dashboard_profile_staff_suggestion/models/suggestion_request.dart
import 'dart:convert';

class NewSuggestionRequest {
  final String plantId;
  final String suggestionTypeId;
  final String name;
  final String description;
  final String status;
  final String impactEstimate;
  final String comment;

  NewSuggestionRequest({
    required this.plantId,
    required this.suggestionTypeId,
    required this.name,
    required this.description,
    required this.status,
    required this.impactEstimate,
    required this.comment,
  });

  /// 🔸 Convert to Map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'suggestionTypeId': suggestionTypeId,
      'name': name,
      'description': description,
      'status': status,
      'impactEstimate': impactEstimate,
      'comment': comment,
    };
  }

  /// 🔸 Create object from Map (optional, useful for deserialization)
  factory NewSuggestionRequest.fromJson(Map<String, dynamic> json) {
    return NewSuggestionRequest(
      plantId: json['plantId'] as String,
      suggestionTypeId: json['suggestionTypeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      impactEstimate: (json['impactEstimate'] as num) as String,
      comment: json['comment'] as String,
    );
  }

  /// Optional: for debugging / logging
  String toRawJson() => jsonEncode(toJson());
}
