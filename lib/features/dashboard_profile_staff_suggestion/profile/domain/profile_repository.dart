import 'package:easy_ops/core/network/api_result.dart';

abstract class ProfileRepository {
  Future<ApiResult<void>> logout();
}
