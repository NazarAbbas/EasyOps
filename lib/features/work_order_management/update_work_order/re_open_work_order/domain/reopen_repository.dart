import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_response.dart';

abstract class ReopenRepository {
  Future<ApiResult<ReopenWorkOrderResponse>> reopenOrder({
    required String reOpenWorkOrderId,
    required ReOpenWorkOrderRequest reOpenWorkOrderRequest,
  });
}
