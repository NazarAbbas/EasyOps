// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:easy_ops/core/network/ApiService.dart';
// import 'package:easy_ops/core/network/api_result.dart';
// import 'package:easy_ops/core/network/network_exception.dart';
// import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_repository.dart';
// import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_work_order_request.dart';
// import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_response.dart';
// import 'package:get/get.dart';

// class CancelRepositoryImpl implements CancelRepository {
//   final ApiService _apiService = Get.find<ApiService>();

//   @override
//   Future<ApiResult<CancelWorkOrderResponse>> cancelOrder(
//       {required String cancelWorkOrderId,
//       required CancelWorkOrderRequest cancelWorkOrderRequest}) async {
//     try {
//       //final jsonString = jsonEncode(cancelWorkOrderRequest.toJson());
//       final model = await _apiService.cancelWorkOrder(
//           cancelWorkOrderRequest: cancelWorkOrderRequest,
//           workOrderId: cancelWorkOrderId);
//       return ApiResult<CancelWorkOrderResponse>(
//         httpCode: 200,
//         data: model,
//         message: 'Success',
//       );
//     } on DioException catch (e) {
//       final code = e.response?.statusCode ?? 0;
//       final msg = NetworkExceptions.getMessage(e);
//       return ApiResult<CancelWorkOrderResponse>(
//           httpCode: code, data: null, message: msg);
//     } catch (e) {
//       return ApiResult<CancelWorkOrderResponse>(
//         httpCode: 0,
//         data: null,
//         message: e.toString(),
//       );
//     }
//   }
// }
