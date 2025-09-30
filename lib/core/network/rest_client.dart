// lib/network/rest_client.dart
import 'package:dio/dio.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:retrofit/retrofit.dart';
import 'package:easy_ops/features/login/models/login_response.dart';

part 'rest_client.g.dart';

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

  @POST('/work-order/with-media/')
  Future<dynamic> createWorkOrderRequest(
    @Body() CreateWorkOrderRequest body,
  );

  @GET('/shift/')
  Future<ShiftData> getShiftData();

  @GET('/asset/')
  Future<AssetsData> getAssetsData();
}
