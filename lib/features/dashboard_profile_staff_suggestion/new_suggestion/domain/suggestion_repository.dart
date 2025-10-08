import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';

abstract class SuggestionRepository {
  Future<ApiResult<NewSuggestionResponse>> addNewSuggestion(
      {required NewSuggestionRequest newSuggestionRequest});
}
