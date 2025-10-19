import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/models/logout_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/profile/domain/profile_repository.dart';
import 'package:get/get.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<LogoutResponse>> logout() async {
    try {
      await _apiService.logout(); // returns Future<void>
      return ApiResult<LogoutResponse>(
        httpCode: 204,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LogoutResponse>(httpCode: code, message: msg);
    } catch (e) {
      return ApiResult<LogoutResponse>(httpCode: 0, message: e.toString());
    }
  }
}
