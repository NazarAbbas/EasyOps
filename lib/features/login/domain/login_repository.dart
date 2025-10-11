import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/login/models/login_person_details.dart';
import 'package:easy_ops/features/login/models/login_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';

abstract class LoginRepository {
  Future<ApiResult<LoginResponse>> login({
    required String userName,
    required String password,
  });

  Future<ApiResult<LookupData>> dropDownData(int page, int size, String sort);
  Future<ApiResult<ShiftData>> shiftData();
  Future<ApiResult<AssetsData>> assetsData();
  Future<ApiResult<LoginPersonDetails>> loginPersonDetails(String userName);
}
