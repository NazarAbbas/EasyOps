import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/login/domain/repository.dart';
import 'package:easy_ops/features/login/models/login_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/drop_down_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:get/get.dart';

class RepositoryImpl implements Repository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<LoginResponse>> login({
    required String userName,
    required String password,
  }) async {
    try {
      final model = await _apiService.loginWithBasic(
        username: userName,
        password: password,
      );
      return ApiResult<LoginResponse>(
        httpCode: 200,
        data: model,
        message: model.message,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LoginResponse>(httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<LoginResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<DropDownData>> dropDownData(
    int page,
    int size,
    String sort,
  ) async {
    try {
      final dropDownData = await _apiService.dropDownData(
        page: page,
        size: size,
        sort: sort,
      );

      return ApiResult<DropDownData>(
        httpCode: 200,
        data: dropDownData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<DropDownData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<DropDownData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<ShiftData>> shiftData() async {
    try {
      final shiftData = await _apiService.shiftData();

      return ApiResult<ShiftData>(
        httpCode: 200,
        data: shiftData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<ShiftData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<ShiftData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<AssetsData>> assetsData() async {
    try {
      final shiftData = await _apiService.assetsData();

      return ApiResult<AssetsData>(
        httpCode: 200,
        data: shiftData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<AssetsData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<AssetsData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
