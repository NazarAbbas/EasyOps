import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/models/logout_response.dart';

abstract class ProfileRepository {
  Future<ApiResult<LogoutResponse>> logout();
}
