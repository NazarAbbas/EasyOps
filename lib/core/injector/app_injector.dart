import 'package:dio/dio.dart';
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/ApiService.dart';
import 'package:easy_ops/core/network/network_sync_service.dart';
import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/db_repository/assets_repository.dart';
import 'package:easy_ops/database/db_repository/login_person_details_repository.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/database/db_repository/offline_work_order_repository.dart';
import 'package:easy_ops/database/db_repository/shift_repositoty.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppInjector {
  static init() async {
    Get.put<Dio>(Dio()); //initializing Dio
    //Get.put<RestAPI>(RestAPI()); //initializing REST API class
    Get.put<ApiService>(ApiService()); //initializing REST API class
    WidgetsFlutterBinding.ensureInitialized();

    await Get.putAsync<AppDatabase>(permanent: true, () async {
      final db = await $FloorAppDatabase
          .databaseBuilder(Constant.databaseName)
          .build();
      return db;
    });

    // Register repository using the DB above.
    Get.put<LookupRepository>(LookupRepository());
    Get.put<AssetRepository>(AssetRepository());
    Get.put<ShiftRepository>(ShiftRepository());
    Get.put<LoginPersonDetailsRepository>(LoginPersonDetailsRepository());
    Get.put<OfflineWorkOrderRepository>(OfflineWorkOrderRepository(),
        permanent: true);
    Get.put(NetworkSyncService(), permanent: true);
  }
}
