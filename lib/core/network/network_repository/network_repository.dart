import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';
import 'package:easy_ops/features/common_features/login/models/login_response.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/models/pending_activity_request.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/models/pending_activity_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/models/add_spare_parts_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/models/spare_parts_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spare_parts_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/models/logout_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/models/close_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/models/close_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';

abstract class NetworkRepository {
  Future<ApiResult<LoginResponse>> login({
    required String userName,
    required String password,
  });

  Future<ApiResult<LookupData>> dropDownData(int page, int size, String sort);
  Future<ApiResult<ShiftData>> shiftData();
  Future<ApiResult<AssetsData>> assetsData();
  Future<ApiResult<LoginPersonDetails>> loginPersonDetails(String userName);
  Future<ApiResult<OperatorsDetailsResponse>> operatorsDetails();

  Future<ApiResult<CancelWorkOrderResponse>> cancelOrder({
    required String cancelWorkOrderId,
    required CancelWorkOrderRequest cancelWorkOrderRequest,
  });

  Future<ApiResult<NewSuggestionResponse>> addNewSuggestion(
      {required NewSuggestionRequest newSuggestionRequest});

  Future<ApiResult<ReopenWorkOrderResponse>> reopenOrder({
    required String reOpenWorkOrderId,
    required ReOpenWorkOrderRequest reOpenWorkOrderRequest,
  });

  Future<ApiResult<WorkOrderListResponse>> workOrderList();

  Future<ApiResult<LogoutResponse>> logout();

  Future<ApiResult<CreateWorkOrderResponse>> createWorkOrderRequest(
      CreateWorkOrderRequest createWorkOrderRequest);

  Future<ApiResult<SuggestionsResponse>> suggestionList();

  Future<ApiResult<CloseWorkOrderResponse>> closeOrder({
    required String closeWorkOrderId,
    required CloseWorkOrderRequest closeWorkOrderRequest,
  });

  Future<ApiResult<List<AddSparePartsResponse>>> sendBulkSpareRequest(
      String workOrderId, List<SparePartsRequest> sparePartsRequest);

  Future<ApiResult<PendingActivityResponse>> createActivitiesBulk(
      List<PendingActivityRequest> pendingActivityRequest);

  Future<ApiResult<UsersResponse>> getUsersList();
}
