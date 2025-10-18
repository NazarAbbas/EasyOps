import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/domain/close_repository.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_response.dart';
import 'package:get/get.dart';

class CloseRepositoryImpl implements CloseRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<CloseWorkOrderResponse>> closeOrder(
      {required String closeWorkOrderId,
      required CloseWorkOrderRequest closeWorkOrderRequest}) async {
    try {
      final model = await _apiService.closeWorkOrder(
          closeWorkOrderRequest, closeWorkOrderId);
      return ApiResult<CloseWorkOrderResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<CloseWorkOrderResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<CloseWorkOrderResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
