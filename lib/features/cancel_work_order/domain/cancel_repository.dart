import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/cancel_work_order/domain/cancel_work_order_request.dart';
import 'package:easy_ops/features/cancel_work_order/models/cancel_work_order_response.dart';

abstract class CancelRepository {
  Future<ApiResult<CancelWorkOrderResponse>> cancelOrder({
    required String cancelWorkOrderId,
    required CancelWorkOrderRequest cancelWorkOrderRequest,
  });
}
