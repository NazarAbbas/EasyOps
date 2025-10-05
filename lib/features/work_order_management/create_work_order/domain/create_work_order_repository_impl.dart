import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/domain/create_work_order_repository.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:get/get.dart';

class CreateWorkOrderRepositoryImpl implements CreateWorkOrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<CreateWorkOrderResponse>> createWorkOrderRequest(
      CreateWorkOrderRequest createWorkOrderRequest) async {
    try {
      final createWorkOrderResponse =
          await _apiService.createWorkOrder(createWorkOrderRequest);

      return ApiResult<CreateWorkOrderResponse>(
          httpCode: 201, data: createWorkOrderResponse, message: 'Success');
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<CreateWorkOrderResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<CreateWorkOrderResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
