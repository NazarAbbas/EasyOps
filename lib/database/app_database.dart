// app_database.dart
import 'dart:async';

import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:easy_ops/database/converter/epoch_datetime_converter.dart';
import 'package:easy_ops/database/dao/assets_dao.dart';
import 'package:easy_ops/database/dao/get_plants_org_dao.dart';
import 'package:easy_ops/database/dao/login_person_details_dao.dart';
import 'package:easy_ops/database/dao/lookup_dao.dart';
import 'package:easy_ops/database/dao/offline_work_order_dao.dart';
import 'package:easy_ops/database/dao/operators_details_dao.dart';
import 'package:easy_ops/database/dao/organization_dao.dart';
import 'package:easy_ops/database/dao/shift_dao.dart';
import 'package:easy_ops/database/dao/user_list_dao.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/database/entity/login_person_details_entity.dart';
import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/database/entity/offline_work_order_entity.dart';
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:easy_ops/database/entity/organizations_entity.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';
import 'package:easy_ops/database/entity/user_list_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/get_plants_org_entity.dart';

part 'app_database.g.dart';

@TypeConverters([EpochDateTimeConverter])
@Database(version: 1, entities: [
  LookupEntity,
  AssetEntity,
  ShiftEntity,
  OfflineWorkOrderEntity,
  LoginPersonDetailsEntity,
  LoginPersonAttendanceEntity,
  LoginPersonContactEntity,
  LoginPersonAssetEntity,
  OperatorsDetailsEntity,
  LoginPersonHolidayEntity,
  OrganizationEntity,
  UserListEntity,
  PlantsOrgEntity,
])
abstract class AppDatabase extends FloorDatabase {
  LoginPersonDetailsDao get loginPersonDao;
  LoginPersonContactDao get loginPersonContactDao;
  LoginPersonAttendanceDao get loginPersonAttendanceDao;
  LoginPersonAssetDao get loginPersonAssetDao;
  LookupDao get lookupDao;
  AssetDao get assetDao;
  ShiftDao get shiftDao;
  PlantsOrgDao get plantsOrgDao;
  OfflineWorkOrderDao get offlineWorkOrderDao;
  OperatorsDetailsDao get operatorsDetailsDao;
  LoginPersonHolidaysDao get loginPersonHolidaysDao;
  UserListDao get userListDao;
  OrganizationDao get organizationDao;
}
