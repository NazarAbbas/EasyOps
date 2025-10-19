import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/domain/work_order_list_repository.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:get/get.dart';

class WorkOrderListRepositoryImpl implements WorkOrderListRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<WorkOrderListResponse>> workOrderList() async {
    try {
      final workOrderListRepository = await _apiService.workOrderList();

      return ApiResult<WorkOrderListResponse>(
          httpCode: 200, data: workOrderListRepository, message: 'Success');
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<WorkOrderListResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<WorkOrderListResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
