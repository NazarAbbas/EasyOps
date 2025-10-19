import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_response.dart';

abstract class CancelRepository {
  Future<ApiResult<CancelWorkOrderResponse>> cancelOrder({
    required String cancelWorkOrderId,
    required CancelWorkOrderRequest cancelWorkOrderRequest,
  });
}
