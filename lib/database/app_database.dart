// app_database.dart
import 'dart:async';

import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:easy_ops/database/dao/assets_dao.dart';
import 'package:easy_ops/database/dao/lookup_dao.dart';
import 'package:easy_ops/database/dao/offline_work_order_dao.dart';
import 'package:easy_ops/database/dao/shift_dao.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/database/entity/offline_work_order_entity.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
    version: 1,
    entities: [LookupEntity, AssetEntity, ShiftEntity, OfflineWorkOrderEntity])
abstract class AppDatabase extends FloorDatabase {
  LookupDao get lookupDao;
  AssetDao get assetDao;
  ShiftDao get shiftDao;
  OfflineWorkOrderDao get offlineWorkOrderDao;
}
