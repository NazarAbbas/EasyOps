// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LookupDao? _lookupDaoInstance;

  AssetDao? _assetDaoInstance;

  ShiftDao? _shiftDaoInstance;

  OfflineWorkOrderDao? _offlineWorkOrderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `lookup` (`id` TEXT NOT NULL, `code` TEXT NOT NULL, `displayName` TEXT NOT NULL, `description` TEXT NOT NULL, `lookupType` TEXT NOT NULL, `sortOrder` INTEGER NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `assets` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `criticality` TEXT NOT NULL, `description` TEXT, `serialNumber` TEXT NOT NULL, `manufacturer` TEXT, `manufacturerPhone` TEXT, `manufacturerEmail` TEXT, `manufacturerAddress` TEXT, `status` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, `plantId` TEXT NOT NULL, `departmentId` TEXT NOT NULL, `plantName` TEXT, `departmentName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `shifts` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `startTime` TEXT NOT NULL, `endTime` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `offline_workorders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `type` TEXT NOT NULL, `priority` TEXT NOT NULL, `status` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `remark` TEXT NOT NULL, `scheduledStart` TEXT NOT NULL, `scheduledEnd` TEXT NOT NULL, `assetId` TEXT NOT NULL, `plantId` TEXT NOT NULL, `departmentId` TEXT NOT NULL, `issueTypeId` TEXT NOT NULL, `impactId` TEXT NOT NULL, `shiftId` TEXT NOT NULL, `mediaFilesJson` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `synced` TEXT NOT NULL)');
        await database.execute(
            'CREATE INDEX `index_lookup_tenantId_clientId_lookupType` ON `lookup` (`tenantId`, `clientId`, `lookupType`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_lookup_tenantId_clientId_lookupType_code` ON `lookup` (`tenantId`, `clientId`, `lookupType`, `code`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_assets_tenantId_clientId_serialNumber` ON `assets` (`tenantId`, `clientId`, `serialNumber`)');
        await database.execute(
            'CREATE INDEX `index_assets_tenantId_clientId_plantId` ON `assets` (`tenantId`, `clientId`, `plantId`)');
        await database.execute(
            'CREATE INDEX `index_assets_tenantId_clientId_departmentId` ON `assets` (`tenantId`, `clientId`, `departmentId`)');
        await database.execute(
            'CREATE INDEX `index_assets_tenantId_clientId_status` ON `assets` (`tenantId`, `clientId`, `status`)');
        await database.execute(
            'CREATE INDEX `index_assets_updatedAt` ON `assets` (`updatedAt`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_shifts_tenantId_clientId_name` ON `shifts` (`tenantId`, `clientId`, `name`)');
        await database.execute(
            'CREATE INDEX `index_shifts_tenantId_clientId` ON `shifts` (`tenantId`, `clientId`)');
        await database.execute(
            'CREATE INDEX `index_shifts_updatedAt` ON `shifts` (`updatedAt`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LookupDao get lookupDao {
    return _lookupDaoInstance ??= _$LookupDao(database, changeListener);
  }

  @override
  AssetDao get assetDao {
    return _assetDaoInstance ??= _$AssetDao(database, changeListener);
  }

  @override
  ShiftDao get shiftDao {
    return _shiftDaoInstance ??= _$ShiftDao(database, changeListener);
  }

  @override
  OfflineWorkOrderDao get offlineWorkOrderDao {
    return _offlineWorkOrderDaoInstance ??=
        _$OfflineWorkOrderDao(database, changeListener);
  }
}

class _$LookupDao extends LookupDao {
  _$LookupDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _lookupEntityInsertionAdapter = InsertionAdapter(
            database,
            'lookup',
            (LookupEntity item) => <String, Object?>{
                  'id': item.id,
                  'code': item.code,
                  'displayName': item.displayName,
                  'description': item.description,
                  'lookupType': _lookupTypeConverter.encode(item.lookupType),
                  'sortOrder': item.sortOrder,
                  'recordStatus': item.recordStatus,
                  'updatedAt': _dateTimeIsoConverter.encode(item.updatedAt),
                  'tenantId': item.tenantId,
                  'clientId': item.clientId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LookupEntity> _lookupEntityInsertionAdapter;

  @override
  Future<List<LookupEntity>> getActiveByType(LookupType lookupType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM lookup     WHERE lookupType = ?1       AND recordStatus = 1     ORDER BY sortOrder',
        mapper: (Map<String, Object?> row) => LookupEntity(id: row['id'] as String, code: row['code'] as String, displayName: row['displayName'] as String, description: row['description'] as String, lookupType: _lookupTypeConverter.decode(row['lookupType'] as String), sortOrder: row['sortOrder'] as int, recordStatus: row['recordStatus'] as int, updatedAt: _dateTimeIsoConverter.decode(row['updatedAt'] as String), tenantId: row['tenantId'] as String, clientId: row['clientId'] as String),
        arguments: [_lookupTypeConverter.encode(lookupType)]);
  }

  @override
  Future<void> upsertAll(List<LookupEntity> rows) async {
    await _lookupEntityInsertionAdapter.insertList(
        rows, OnConflictStrategy.replace);
  }
}

class _$AssetDao extends AssetDao {
  _$AssetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _assetEntityInsertionAdapter = InsertionAdapter(
            database,
            'assets',
            (AssetEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'criticality': _criticalityConverter.encode(item.criticality),
                  'description': item.description,
                  'serialNumber': item.serialNumber,
                  'manufacturer': item.manufacturer,
                  'manufacturerPhone': item.manufacturerPhone,
                  'manufacturerEmail': item.manufacturerEmail,
                  'manufacturerAddress': item.manufacturerAddress,
                  'status': _assetStatusConverter.encode(item.status),
                  'recordStatus': item.recordStatus,
                  'updatedAt': _dateTimeIsoConverter.encode(item.updatedAt),
                  'tenantId': item.tenantId,
                  'clientId': item.clientId,
                  'plantId': item.plantId,
                  'departmentId': item.departmentId,
                  'plantName': item.plantName,
                  'departmentName': item.departmentName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AssetEntity> _assetEntityInsertionAdapter;

  @override
  Future<List<AssetEntity>> getAllAssets() async {
    return _queryAdapter.queryList(
        'SELECT * FROM assets     WHERE recordStatus = 1     ORDER BY name',
        mapper: (Map<String, Object?> row) => AssetEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            criticality:
                _criticalityConverter.decode(row['criticality'] as String),
            description: row['description'] as String?,
            serialNumber: row['serialNumber'] as String,
            manufacturer: row['manufacturer'] as String?,
            manufacturerPhone: row['manufacturerPhone'] as String?,
            manufacturerEmail: row['manufacturerEmail'] as String?,
            manufacturerAddress: row['manufacturerAddress'] as String?,
            status: _assetStatusConverter.decode(row['status'] as String),
            recordStatus: row['recordStatus'] as int,
            updatedAt: _dateTimeIsoConverter.decode(row['updatedAt'] as String),
            tenantId: row['tenantId'] as String,
            clientId: row['clientId'] as String,
            plantId: row['plantId'] as String,
            departmentId: row['departmentId'] as String,
            plantName: row['plantName'] as String?,
            departmentName: row['departmentName'] as String?));
  }

  @override
  Future<void> upsertAll(List<AssetEntity> items) async {
    await _assetEntityInsertionAdapter.insertList(
        items, OnConflictStrategy.replace);
  }
}

class _$ShiftDao extends ShiftDao {
  _$ShiftDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _shiftEntityInsertionAdapter = InsertionAdapter(
            database,
            'shifts',
            (ShiftEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'recordStatus': item.recordStatus,
                  'updatedAt': _dateTimeIsoConverter.encode(item.updatedAt),
                  'tenantId': item.tenantId,
                  'clientId': item.clientId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ShiftEntity> _shiftEntityInsertionAdapter;

  @override
  Future<List<ShiftEntity>> getAllShift() async {
    return _queryAdapter.queryList(
        'SELECT * FROM shifts     WHERE recordStatus = 1     ORDER BY name',
        mapper: (Map<String, Object?> row) => ShiftEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            startTime: row['startTime'] as String,
            endTime: row['endTime'] as String,
            recordStatus: row['recordStatus'] as int,
            updatedAt: _dateTimeIsoConverter.decode(row['updatedAt'] as String),
            tenantId: row['tenantId'] as String,
            clientId: row['clientId'] as String));
  }

  @override
  Future<void> upsertAllShift(List<ShiftEntity> items) async {
    await _shiftEntityInsertionAdapter.insertList(
        items, OnConflictStrategy.replace);
  }
}

class _$OfflineWorkOrderDao extends OfflineWorkOrderDao {
  _$OfflineWorkOrderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _offlineWorkOrderEntityInsertionAdapter = InsertionAdapter(
            database,
            'offline_workorders',
            (OfflineWorkOrderEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'priority': item.priority,
                  'status': item.status,
                  'title': item.title,
                  'description': item.description,
                  'remark': item.remark,
                  'scheduledStart': item.scheduledStart,
                  'scheduledEnd': item.scheduledEnd,
                  'assetId': item.assetId,
                  'plantId': item.plantId,
                  'departmentId': item.departmentId,
                  'issueTypeId': item.issueTypeId,
                  'impactId': item.impactId,
                  'shiftId': item.shiftId,
                  'mediaFilesJson': item.mediaFilesJson,
                  'createdAt': item.createdAt,
                  'synced': item.synced
                }),
        _offlineWorkOrderEntityDeletionAdapter = DeletionAdapter(
            database,
            'offline_workorders',
            ['id'],
            (OfflineWorkOrderEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'priority': item.priority,
                  'status': item.status,
                  'title': item.title,
                  'description': item.description,
                  'remark': item.remark,
                  'scheduledStart': item.scheduledStart,
                  'scheduledEnd': item.scheduledEnd,
                  'assetId': item.assetId,
                  'plantId': item.plantId,
                  'departmentId': item.departmentId,
                  'issueTypeId': item.issueTypeId,
                  'impactId': item.impactId,
                  'shiftId': item.shiftId,
                  'mediaFilesJson': item.mediaFilesJson,
                  'createdAt': item.createdAt,
                  'synced': item.synced
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OfflineWorkOrderEntity>
      _offlineWorkOrderEntityInsertionAdapter;

  final DeletionAdapter<OfflineWorkOrderEntity>
      _offlineWorkOrderEntityDeletionAdapter;

  @override
  Future<List<OfflineWorkOrderEntity>> getUnsynced() async {
    return _queryAdapter.queryList(
        'SELECT * FROM offline_workorders WHERE synced = \"false\"',
        mapper: (Map<String, Object?> row) => OfflineWorkOrderEntity(
            id: row['id'] as int?,
            type: row['type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            remark: row['remark'] as String,
            scheduledStart: row['scheduledStart'] as String,
            scheduledEnd: row['scheduledEnd'] as String,
            assetId: row['assetId'] as String,
            plantId: row['plantId'] as String,
            departmentId: row['departmentId'] as String,
            issueTypeId: row['issueTypeId'] as String,
            impactId: row['impactId'] as String,
            shiftId: row['shiftId'] as String,
            mediaFilesJson: row['mediaFilesJson'] as String,
            createdAt: row['createdAt'] as String,
            synced: row['synced'] as String));
  }

  @override
  Future<void> updateSyncStatus(
    int id,
    String status,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE offline_workorders SET synced = ?2 WHERE id = ?1',
        arguments: [id, status]);
  }

  @override
  Future<void> insertWorkOrder(OfflineWorkOrderEntity order) async {
    await _offlineWorkOrderEntityInsertionAdapter.insert(
        order, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWorkOrder(OfflineWorkOrderEntity order) async {
    await _offlineWorkOrderEntityDeletionAdapter.delete(order);
  }
}

// ignore_for_file: unused_element
final _lookupTypeConverter = LookupTypeConverter();
final _dateTimeIsoConverter = DateTimeIsoConverter();
final _criticalityConverter = CriticalityConverter();
final _assetStatusConverter = AssetStatusConverter();
