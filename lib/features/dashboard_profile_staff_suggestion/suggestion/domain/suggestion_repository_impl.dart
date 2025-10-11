import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/domain/suggestion_repository.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:get/get.dart';

class SuggestionRepositoryImpl implements SuggestionRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<SuggestionsResponse>> suggestionList() async {
    try {
      final model = await _apiService.suggestionList();

      return ApiResult<SuggestionsResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<SuggestionsResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<SuggestionsResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
