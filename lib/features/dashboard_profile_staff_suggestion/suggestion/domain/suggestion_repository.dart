import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';

abstract class SuggestionRepository {
  Future<ApiResult<SuggestionsResponse>> suggestionList();
}
