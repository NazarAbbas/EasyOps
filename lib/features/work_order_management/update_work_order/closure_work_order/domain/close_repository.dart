import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_response.dart';

abstract class CloseRepository {
  Future<ApiResult<CloseWorkOrderResponse>> closeOrder({
    required String closeWorkOrderId,
    required CloseWorkOrderRequest closeWorkOrderRequest,
  });
}
