// lib/network/rest_client.dart
import 'package:dio/dio.dart' hide Headers;
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/models/pending_activity_request.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/models/pending_activity_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_request.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/models/add_spare_parts_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/models/spare_parts_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spare_parts_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/models/logout_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/models/close_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:easy_ops/features/common_features/login/models/login_response.dart';

part 'rest_client.g.dart';

// Define this at the top of the file or in a constants file

@RestApi(baseUrl: 'https://216.48.186.237:8443/v1/api')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // login: send Basic in header; tokens come back in response headers
  @POST('/user-login')
  Future<LoginResponse> loginBasic(@Header('Authorization') String auth);

  @GET('/client-lookup/')
  Future<LookupData> getDropDownData({
    @Query('page') int page = 0,
    @Query('size') int size = 20,
    @Query('sort') String sort = 'sort_order,asc',
  });

  @POST('/work-order/with-media')
  @Headers(<String, String>{'Content-Type': 'multipart/form-data'})
  Future<CreateWorkOrderResponse> createWorkOrderRequest(
      @Body() FormData formData);

  @PUT('/work-order/{id}/with-media')
  @Headers(<String, String>{'Content-Type': 'multipart/form-data'})
  Future<CloseWorkOrderResponse> closeWorkOrder(@Path('id') String workOrderId,
      @Body() FormData formData // <- FormData body
      );

  @GET('/work-order/')
  Future<WorkOrderListResponse> getWorkOrderList();

  @GET('/shift/')
  Future<ShiftData> getShiftData();

  @GET('/asset-spare/by-criteria')
  Future<List<SparePartsResponse>> spareParts({
    @Query('assetId') required String assetId,
    @Query('partCat1Id') required String partCat1Id,
    @Query('partCat2Id') required String partCat2Id,
  });

  @GET('/asset/')
  Future<AssetsData> getAssetsData();

  @POST('/logout')
  Future<LogoutResponse> logout();

  @POST('/suggestion/')
  Future<NewSuggestionResponse> addNewSuggestion(
    @Body() NewSuggestionRequest body,
  );

  @GET('/suggestion/')
  Future<SuggestionsResponse> suggestionList();

  @GET('/person/details-by-username')
  Future<LoginPersonDetails> loginPersonDetails(
    @Query('username') String username,
  );

  @Headers(<String, String>{'Content-Type': 'multipart/form-data'})
  @PUT('/work-order/{id}/with-media')
  Future<CancelWorkOrderResponse> cancelWorkOrder(
      @Path('id') String workOrderId,
      @Body() FormData formData // <- accepts your JSON string
      );

  @Headers(<String, String>{'Content-Type': 'multipart/form-data'})
  @PUT('/work-order/{id}/with-media')
  Future<ReopenWorkOrderResponse> reOpenWorkOrder(
      @Path('id') String workOrderId,
      @Body() FormData formData // <- accepts your JSON string
      );

  @GET('/person/')
  Future<OperatorsDetailsResponse> operatorDetails();

  @POST('/work-order-spare-part/bulk/{workOrderId}')
  Future<List<AddSparePartsResponse>> bulkSparePartRequest(
    @Path('workOrderId') String workOrderId,
    @Body() List<SparePartsRequest> lines,
  );

  @POST('/work-order-rca/')
  Future<RcaResponse> createRca(
    @Body() RcaRequest body,
  );

  /// Sends a JSON array body
  @POST('work-order-activity/bulk')
  Future<PendingActivityResponse> createActivitiesBulk(
      @Body() List<PendingActivityRequest> items);

  @GET('/user/')
  Future<UsersResponse> getUsersList();
}
