import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/core/network/network_repository/network_repository.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';
import 'package:easy_ops/features/common_features/login/models/login_response.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_request.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_response.dart';
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
import 'package:get/get.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<ApiResult<LoginResponse>> login({
    required String userName,
    required String password,
  }) async {
    try {
      final model = await _apiService.loginWithBasic(
        username: userName,
        password: password,
      );
      return ApiResult<LoginResponse>(
        httpCode: 200,
        data: model,
        message: model.message,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LoginResponse>(httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<LoginResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<LookupData>> dropDownData(
    int page,
    int size,
    String sort,
  ) async {
    try {
      final dropDownData = await _apiService.dropDownData(
        page: page,
        size: size,
        sort: sort,
      );

      return ApiResult<LookupData>(
        httpCode: 200,
        data: dropDownData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LookupData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<LookupData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<ShiftData>> shiftData() async {
    try {
      final shiftData = await _apiService.shiftData();

      return ApiResult<ShiftData>(
        httpCode: 200,
        data: shiftData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<ShiftData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<ShiftData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<AssetsData>> assetsData() async {
    try {
      final shiftData = await _apiService.assetsData();

      return ApiResult<AssetsData>(
        httpCode: 200,
        data: shiftData,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<AssetsData>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<AssetsData>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<LoginPersonDetails>> loginPersonDetails(
      String userName) async {
    try {
      final result = await _apiService.loginPersonDetails(userName);

      return ApiResult<LoginPersonDetails>(
        httpCode: 200,
        data: result,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LoginPersonDetails>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<LoginPersonDetails>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<OperatorsDetailsResponse>> operatorsDetails() async {
    try {
      final result = await _apiService.operatorDetails();

      return ApiResult<OperatorsDetailsResponse>(
        httpCode: 200,
        data: result,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<OperatorsDetailsResponse>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<OperatorsDetailsResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<CancelWorkOrderResponse>> cancelOrder(
      {required String cancelWorkOrderId,
      required CancelWorkOrderRequest cancelWorkOrderRequest}) async {
    try {
      //final jsonString = jsonEncode(cancelWorkOrderRequest.toJson());
      final model = await _apiService.cancelWorkOrder(
          cancelWorkOrderRequest: cancelWorkOrderRequest,
          workOrderId: cancelWorkOrderId);
      return ApiResult<CancelWorkOrderResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<CancelWorkOrderResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<CancelWorkOrderResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<NewSuggestionResponse>> addNewSuggestion(
      {required NewSuggestionRequest newSuggestionRequest}) async {
    try {
      final model = await _apiService.addNewSuggestion(newSuggestionRequest);

      return ApiResult<NewSuggestionResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<NewSuggestionResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<NewSuggestionResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<ReopenWorkOrderResponse>> reopenOrder(
      {required String reOpenWorkOrderId,
      required ReOpenWorkOrderRequest reOpenWorkOrderRequest}) async {
    try {
      //final jsonString = jsonEncode(cancelWorkOrderRequest.toJson());
      final model = await _apiService.reOpenWorkOrder(
          reOpenWorkOrderRequest: reOpenWorkOrderRequest,
          workOrderId: reOpenWorkOrderId);
      return ApiResult<ReopenWorkOrderResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<ReopenWorkOrderResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<ReopenWorkOrderResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<WorkOrderListResponse>> workOrderList() async {
    try {
      final workOrderListRepository = await _apiService.workOrderList();

      return ApiResult<WorkOrderListResponse>(
          httpCode: 200, data: workOrderListRepository, message: 'Success');
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<WorkOrderListResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<WorkOrderListResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<LogoutResponse>> logout() async {
    try {
      await _apiService.logout(); // returns Future<void>
      return ApiResult<LogoutResponse>(
        httpCode: 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<LogoutResponse>(httpCode: code, message: msg);
    } catch (e) {
      return ApiResult<LogoutResponse>(httpCode: 0, message: e.toString());
    }
  }

  @override
  Future<ApiResult<CreateWorkOrderResponse>> createWorkOrderRequest(
      CreateWorkOrderRequest createWorkOrderRequest) async {
    try {
      // ✅ Call API service (which should internally handle JSON or multipart)
      final createWorkOrderResponse =
          await _apiService.createWorkOrder(createWorkOrderRequest);

      return ApiResult<CreateWorkOrderResponse>(
        httpCode: 201,
        data: createWorkOrderResponse,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<CreateWorkOrderResponse>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<CreateWorkOrderResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<SuggestionsResponse>> suggestionList() async {
    try {
      final model = await _apiService.suggestionList();

      return ApiResult<SuggestionsResponse>(
        httpCode: 200,
        data: model,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<SuggestionsResponse>(
          httpCode: code, data: null, message: msg);
    } catch (e) {
      return ApiResult<SuggestionsResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

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

  @override
  Future<ApiResult<List<SparePartsResponse>>> spareParts(
    String? assetId,
    String? partCat1Id,
    String? partCat2Id,
  ) async {
    try {
      final result = await _apiService.spareParts(
          assetId: assetId, partCat1Id: partCat1Id, partCat2Id: partCat2Id);

      return ApiResult<List<SparePartsResponse>>(
        httpCode: 200,
        data: result,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<List<SparePartsResponse>>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<List<SparePartsResponse>>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<SparePartsResponse>> sendBulkSpareRequest(
      String workOrderId, List<SparePartsRequest> sparePartsRequest) async {
    try {
      final result = await _apiService.sendBulkSpareRequest(
          workOrderId, sparePartsRequest);

      return ApiResult<SparePartsResponse>(
        httpCode: 200,
        data: result,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<SparePartsResponse>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<SparePartsResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResult<RcaResponse>> createRca(RcaRequest rcaRequest) async {
    try {
      final result = await _apiService.createRca(rcaRequest);

      return ApiResult<RcaResponse>(
        httpCode: 200,
        data: result,
        message: 'Success',
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = NetworkExceptions.getMessage(e);
      return ApiResult<RcaResponse>(
        httpCode: code,
        data: null,
        message: msg,
      );
    } catch (e) {
      return ApiResult<RcaResponse>(
        httpCode: 0,
        data: null,
        message: e.toString(),
      );
    }
  }
}
