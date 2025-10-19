// lib/features/dashboard_profile_staff_suggestion/models/new_suggestion_response.dart
// lib/models/suggestion.dart

class NewSuggestionResponse {
  final String id;
  final String plantId;
  final String suggestionTypeId;
  final String name;
  final String description;
  final String status;
  final double impactEstimate;
  final String comment;
  final int recordStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdById;
  final String updatedById;

  NewSuggestionResponse({
    required this.id,
    required this.plantId,
    required this.suggestionTypeId,
    required this.name,
    required this.description,
    required this.status,
    required this.impactEstimate,
    required this.comment,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.createdById,
    required this.updatedById,
  });

  factory NewSuggestionResponse.fromJson(Map<String, dynamic> json) {
    return NewSuggestionResponse(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      suggestionTypeId: json['suggestionTypeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      impactEstimate: (json['impactEstimate'] as num).toDouble(),
      comment: json['comment'] as String,
      recordStatus: json['recordStatus'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdById: json['createdById'] as String,
      updatedById: json['updatedById'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'suggestionTypeId': suggestionTypeId,
      'name': name,
      'description': description,
      'status': status,
      'impactEstimate': impactEstimate,
      'comment': comment,
      'recordStatus': recordStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdById': createdById,
      'updatedById': updatedById,
    };
  }
}
