import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';

abstract class Repository {
  Future<ApiResult<dynamic>> createWorkOrderRequest(
      CreateWorkOrderRequest createWorkOrderRequest);
}
