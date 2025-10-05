// lib/network/api_service.dart
import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/api_factory.dart';
import 'package:easy_ops/core/network/auth_store.dart';
import 'package:easy_ops/core/network/basic_auth_header.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/core/network/rest_client.dart';
import 'package:easy_ops/features/login/models/login_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';

class ApiService {
  late final RestClient _api;

  ApiService() {
    _api = createRestClient();
  }

  /// Login with Basic auth. Tokens are captured from headers by interceptor.
  Future<LoginResponse> loginWithBasic({
    required String username,
    required String password,
    bool preferRefreshForOtherApis =
        false, // change Token from here<— toggle can be set here
  }) async {
    try {
      final res = await _api.loginBasic(basicAuthHeader(username, password));
      await AuthStore.instance.setUseRefreshForAuth(preferRefreshForOtherApis);
      return res;
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<LookupData> dropDownData({
    int page = 0,
    int size = 100,
    String sort = 'sort_order,asc',
  }) async {
    try {
      return await _api.getDropDownData(
        page: page,
        size: size,
        sort: sort,
      );
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<ShiftData> shiftData({
    int page = 0,
    int size = 100,
    String sort = 'sort_order,asc',
  }) async {
    try {
      return await _api.getShiftData();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<AssetsData> assetsData() async {
    try {
      return await _api.getAssetsData();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<CreateWorkOrderResponse> createWorkOrder(
      CreateWorkOrderRequest createWorkOrderRequest) async {
    try {
      return await _api.createWorkOrderRequest(createWorkOrderRequest);
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<WorkOrderListResponse> workOrderList() async {
    try {
      return await _api.getWorkOrderList();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  /// Change the token used on subsequent API calls at runtime.
  Future<void> useRefreshForOtherApis(bool value) =>
      AuthStore.instance.setUseRefreshForAuth(value);
}
