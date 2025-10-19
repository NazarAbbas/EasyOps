import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/domain/new_suggestion_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';
import 'package:get/get.dart';

class NewSuggestionRepositoryImpl implements NewSuggestionRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<NewSuggestionResponse>> addNewSuggestion(
      {required NewSuggestionRequest newSuggestionRequest}) async {
    try {
      final model = await _apiService.addNewSuggestion(newSuggestionRequest);

      return ApiResult<NewSuggestionResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<NewSuggestionResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<NewSuggestionResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
