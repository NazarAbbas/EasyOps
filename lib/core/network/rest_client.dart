// lib/network/rest_client.dart
import 'package:dio/dio.dart' hide Headers;
import 'package:easy_ops/features/cancel_work_order/domain/cancel_work_order_request.dart';
import 'package:easy_ops/features/cancel_work_order/models/cancel_work_order_response.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/home_dashboard/models/logout_response.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:easy_ops/features/login/models/login_person_details.dart';
import 'package:easy_ops/features/login/models/operators_details.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_response.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_response.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:easy_ops/features/login/models/login_response.dart';

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
}
