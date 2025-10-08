// lib/network/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_response.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/ui/new_suggestion_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:easy_ops/core/network/api_factory.dart';
import 'package:easy_ops/core/network/auth_store.dart';
import 'package:easy_ops/core/network/basic_auth_header.dart';
import 'package:easy_ops/core/network/network_exception.dart';
import 'package:easy_ops/core/network/rest_client.dart';
import 'package:easy_ops/features/login/models/login_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_response.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';

class ApiService {
  late final RestClient _api;

  ApiService() {
    _api = createRestClient();
  }

  /// Login with Basic auth. Tokens are captured from headers by interceptor.
  Future<LoginResponse> loginWithBasic({
    required String username,
    required String password,
    bool preferRefreshForOtherApis =
        false, // change Token from here<— toggle can be set here
  }) async {
    try {
      final res = await _api.loginBasic(basicAuthHeader(username, password));
      await AuthStore.instance.setUseRefreshForAuth(preferRefreshForOtherApis);
      return res;
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<LookupData> dropDownData({
    int page = 0,
    int size = 100,
    String sort = 'sort_order,asc',
  }) async {
    try {
      return await _api.getDropDownData(
        page: page,
        size: size,
        sort: sort,
      );
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<ShiftData> shiftData({
    int page = 0,
    int size = 100,
    String sort = 'sort_order,asc',
  }) async {
    try {
      return await _api.getShiftData();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<AssetsData> assetsData() async {
    try {
      return await _api.getAssetsData();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<CreateWorkOrderResponse> createWorkOrder(
    CreateWorkOrderRequest req,
  ) async {
    try {
      // 1️⃣ Encode the workOrder JSON and wrap it as a JSON multipart part
      final jsonString = jsonEncode(req.toJson());
      final workOrderPart = MultipartFile.fromString(
        jsonString,
        contentType: MediaType('application', 'json'),
        filename: 'workOrder.json', // helps some servers
      );

      // 2️⃣ Collect file parts
      final fileEntries = <MapEntry<String, MultipartFile>>[];
      for (final media in req.mediaFiles) {
        final file = File(media.filePath);
        if (await file.exists()) {
          final fileName = file.path.split('/').last;
          fileEntries.add(
            MapEntry(
              'files', // matches your curl's `--form 'files=@...'`
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      // 3️⃣ Build the FormData (mimics the cURL structure)
      final formData = FormData();
      formData.files.add(MapEntry('workOrder', workOrderPart));
      formData.files.addAll(fileEntries);

      // 4️⃣ Call Retrofit client (Dio runs internally — no manual post())
      return _api.createWorkOrderRequest(formData);
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<WorkOrderListResponse> workOrderList() async {
    try {
      return await _api.getWorkOrderList();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  Future<NewSuggestionResponse> addNewSuggestion(
      NewSuggestionRequest newSuggestionRequest) async {
    try {
      return await _api.addNewSuggestion(newSuggestionRequest);
    } on DioException catch (e) {
      throw Exception(NetworkExceptions.getMessage(e));
    }
  }

  /// Change the token used on subsequent API calls at runtime.
  Future<void> useRefreshForOtherApis(bool value) =>
      AuthStore.instance.setUseRefreshForAuth(value);
}
