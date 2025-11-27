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

  LoginPersonDetailsDao? _loginPersonDaoInstance;

  LoginPersonContactDao? _loginPersonContactDaoInstance;

  LoginPersonAttendanceDao? _loginPersonAttendanceDaoInstance;

  LoginPersonAssetDao? _loginPersonAssetDaoInstance;

  LookupDao? _lookupDaoInstance;

  AssetDao? _assetDaoInstance;

  ShiftDao? _shiftDaoInstance;

  PlantsOrgDao? _plantsOrgDaoInstance;

  OfflineWorkOrderDao? _offlineWorkOrderDaoInstance;

  OperatorsDetailsDao? _operatorsDetailsDaoInstance;

  LoginPersonHolidaysDao? _loginPersonHolidaysDaoInstance;

  UserListDao? _userListDaoInstance;

  OrganizationDao? _organizationDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `lookup` (`id` TEXT NOT NULL, `code` TEXT NOT NULL, `displayName` TEXT NOT NULL, `lookupType` TEXT NOT NULL, `sortOrder` INTEGER NOT NULL, `recordStatus` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `assets` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `criticality` TEXT NOT NULL, `description` TEXT, `serialNumber` TEXT NOT NULL, `manufacturer` TEXT, `manufacturerPhone` TEXT, `manufacturerEmail` TEXT, `manufacturerAddress` TEXT, `status` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, `plantId` TEXT NOT NULL, `plantName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `shifts` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `startTime` TEXT NOT NULL, `endTime` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `offline_workorders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `operatorName` TEXT NOT NULL, `operatorId` TEXT NOT NULL, `operatorPhoneNumber` TEXT NOT NULL, `categoryId` TEXT NOT NULL, `categoryName` TEXT NOT NULL, `reporterId` TEXT NOT NULL, `reporterName` TEXT NOT NULL, `reporterPhoneNumber` TEXT NOT NULL, `type` TEXT NOT NULL, `priority` TEXT NOT NULL, `status` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `remark` TEXT NOT NULL, `scheduledStart` TEXT NOT NULL, `scheduledEnd` TEXT NOT NULL, `assetId` TEXT NOT NULL, `plantId` TEXT NOT NULL, `departmentId` TEXT NOT NULL, `issueTypeId` TEXT NOT NULL, `impactId` TEXT NOT NULL, `shiftId` TEXT NOT NULL, `mediaFilesJson` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `synced` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `login_person_details` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `userPhone` TEXT NOT NULL, `dob` TEXT, `bloodGroup` TEXT, `designation` TEXT, `type` TEXT, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `userId` TEXT, `userEmail` TEXT, `organizationId` TEXT, `organizationName` TEXT, `departmentId` TEXT, `departmentName` TEXT, `managerId` TEXT, `managerName` TEXT, `managerContact` TEXT, `shiftId` TEXT, `shiftName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `login_person_attendance` (`id` TEXT NOT NULL, `attDate` TEXT NOT NULL, `checkIn` TEXT, `checkOut` TEXT, `remarks` TEXT, `status` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `personId` TEXT NOT NULL, `personName` TEXT NOT NULL, `shiftId` TEXT, `shiftName` TEXT, FOREIGN KEY (`personId`) REFERENCES `login_person_details` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `login_person_contact` (`id` TEXT NOT NULL, `label` TEXT NOT NULL, `relationship` TEXT, `phone` TEXT, `email` TEXT, `recordStatus` INTEGER NOT NULL, `updatedAt` TEXT NOT NULL, `personId` TEXT NOT NULL, `personName` TEXT NOT NULL, `name` TEXT NOT NULL, FOREIGN KEY (`personId`) REFERENCES `login_person_details` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `login_person_assets` (`id` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `createdAt` TEXT, `personId` TEXT, `personName` TEXT, `assetId` TEXT, `assetName` TEXT, `assetSerialNumber` TEXT, FOREIGN KEY (`personId`) REFERENCES `login_person_details` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `operators_details_entity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `userPhone` TEXT NOT NULL, `dob` INTEGER, `updatedAt` INTEGER, `bloodGroup` TEXT, `designation` TEXT, `type` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `tenantId` TEXT NOT NULL, `clientId` TEXT NOT NULL, `userId` TEXT, `organizationId` TEXT, `parentStaffId` TEXT, `managerId` TEXT, `shiftId` TEXT, `departmentId` TEXT, `userEmail` TEXT, `organizationName` TEXT, `parentStaffName` TEXT, `managerName` TEXT, `shiftName` TEXT, `departmentName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `login_person_holidays` (`id` TEXT NOT NULL, `holidayDate` INTEGER, `holidayName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `organizations` (`id` TEXT NOT NULL, `displayName` TEXT NOT NULL, `orgTypeId` TEXT, `orgTypeName` TEXT, `addressLine1` TEXT, `addressLine2` TEXT, `zip` TEXT, `recordStatus` INTEGER, `tenantId` TEXT, `tenantName` TEXT, `clientId` TEXT, `clientName` TEXT, `parentOrgId` TEXT, `parentOrgName` TEXT, `countryId` TEXT, `countryName` TEXT, `stateId` TEXT, `stateName` TEXT, `districtId` TEXT, `districtName` TEXT, `timezoneId` TEXT, `timezoneName` TEXT, `dateFormatId` TEXT, `languageId` TEXT, `languageName` TEXT, `currencyId` TEXT, `currencyName` TEXT, `taxProfileId` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users_list` (`id` TEXT NOT NULL, `email` TEXT NOT NULL, `communicationEmail` TEXT, `passwordHash` TEXT NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `phone` TEXT NOT NULL, `userType` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `tenantId` TEXT NOT NULL, `tenantName` TEXT NOT NULL, `clientId` TEXT NOT NULL, `clientName` TEXT NOT NULL, `orgId` TEXT, `orgName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `plants_org` (`id` TEXT NOT NULL, `displayName` TEXT NOT NULL, `orgTypeId` TEXT NOT NULL, `orgTypeName` TEXT NOT NULL, `addressLine1` TEXT NOT NULL, `addressLine2` TEXT NOT NULL, `zip` TEXT NOT NULL, `recordStatus` INTEGER NOT NULL, `tenantId` TEXT NOT NULL, `tenantName` TEXT NOT NULL, `clientId` TEXT NOT NULL, `clientName` TEXT NOT NULL, `parentOrgId` TEXT, `parentOrgName` TEXT, `countryId` TEXT NOT NULL, `countryName` TEXT NOT NULL, `stateId` TEXT NOT NULL, `stateName` TEXT NOT NULL, `districtId` TEXT NOT NULL, `districtName` TEXT NOT NULL, `timezoneId` TEXT NOT NULL, `timezoneName` TEXT NOT NULL, `dateFormatId` TEXT NOT NULL, `languageId` TEXT NOT NULL, `languageName` TEXT NOT NULL, `currencyId` TEXT NOT NULL, `currencyName` TEXT NOT NULL, `taxProfileId` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE INDEX `index_lookup_lookupType` ON `lookup` (`lookupType`)');
        await database.execute(
            'CREATE INDEX `index_lookup_lookupType_code` ON `lookup` (`lookupType`, `code`)');
        await database.execute(
            'CREATE INDEX `index_assets_tenantId_clientId_plantId` ON `assets` (`tenantId`, `clientId`, `plantId`)');
        await database.execute(
            'CREATE INDEX `index_assets_tenantId_clientId_serialNumber` ON `assets` (`tenantId`, `clientId`, `serialNumber`)');
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
        await database.execute(
            'CREATE INDEX `index_login_person_assets_personId` ON `login_person_assets` (`personId`)');
        await database.execute(
            'CREATE INDEX `index_login_person_assets_assetId` ON `login_person_assets` (`assetId`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_name` ON `operators_details_entity` (`name`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_tenantId` ON `operators_details_entity` (`tenantId`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_clientId` ON `operators_details_entity` (`clientId`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_organizationId` ON `operators_details_entity` (`organizationId`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_shiftId` ON `operators_details_entity` (`shiftId`)');
        await database.execute(
            'CREATE INDEX `index_operators_details_entity_departmentId` ON `operators_details_entity` (`departmentId`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_organizations_tenantId_clientId_displayName` ON `organizations` (`tenantId`, `clientId`, `displayName`)');
        await database.execute(
            'CREATE INDEX `index_organizations_tenantId_clientId` ON `organizations` (`tenantId`, `clientId`)');
        await database.execute(
            'CREATE INDEX `index_organizations_parentOrgId` ON `organizations` (`parentOrgId`)');
        await database.execute(
            'CREATE INDEX `index_organizations_recordStatus` ON `organizations` (`recordStatus`)');
        await database.execute(
            'CREATE INDEX `index_plants_org_orgTypeId` ON `plants_org` (`orgTypeId`)');
        await database.execute(
            'CREATE INDEX `index_plants_org_orgTypeId_id` ON `plants_org` (`orgTypeId`, `id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LoginPersonDetailsDao get loginPersonDao {
    return _loginPersonDaoInstance ??=
        _$LoginPersonDetailsDao(database, changeListener);
  }

  @override
  LoginPersonContactDao get loginPersonContactDao {
    return _loginPersonContactDaoInstance ??=
        _$LoginPersonContactDao(database, changeListener);
  }

  @override
  LoginPersonAttendanceDao get loginPersonAttendanceDao {
    return _loginPersonAttendanceDaoInstance ??=
        _$LoginPersonAttendanceDao(database, changeListener);
  }

  @override
  LoginPersonAssetDao get loginPersonAssetDao {
    return _loginPersonAssetDaoInstance ??=
        _$LoginPersonAssetDao(database, changeListener);
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
  PlantsOrgDao get plantsOrgDao {
    return _plantsOrgDaoInstance ??= _$PlantsOrgDao(database, changeListener);
  }

  @override
  OfflineWorkOrderDao get offlineWorkOrderDao {
    return _offlineWorkOrderDaoInstance ??=
        _$OfflineWorkOrderDao(database, changeListener);
  }

  @override
  OperatorsDetailsDao get operatorsDetailsDao {
    return _operatorsDetailsDaoInstance ??=
        _$OperatorsDetailsDao(database, changeListener);
  }

  @override
  LoginPersonHolidaysDao get loginPersonHolidaysDao {
    return _loginPersonHolidaysDaoInstance ??=
        _$LoginPersonHolidaysDao(database, changeListener);
  }

  @override
  UserListDao get userListDao {
    return _userListDaoInstance ??= _$UserListDao(database, changeListener);
  }

  @override
  OrganizationDao get organizationDao {
    return _organizationDaoInstance ??=
        _$OrganizationDao(database, changeListener);
  }
}

class _$LoginPersonDetailsDao extends LoginPersonDetailsDao {
  _$LoginPersonDetailsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _loginPersonDetailsEntityInsertionAdapter = InsertionAdapter(
            database,
            'login_person_details',
            (LoginPersonDetailsEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'userPhone': item.userPhone,
                  'dob': item.dob,
                  'bloodGroup': item.bloodGroup,
                  'designation': item.designation,
                  'type': item.type,
                  'recordStatus': item.recordStatus,
                  'updatedAt': item.updatedAt,
                  'userId': item.userId,
                  'userEmail': item.userEmail,
                  'organizationId': item.organizationId,
                  'organizationName': item.organizationName,
                  'departmentId': item.departmentId,
                  'departmentName': item.departmentName,
                  'managerId': item.managerId,
                  'managerName': item.managerName,
                  'managerContact': item.managerContact,
                  'shiftId': item.shiftId,
                  'shiftName': item.shiftName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginPersonDetailsEntity>
      _loginPersonDetailsEntityInsertionAdapter;

  @override
  Future<LoginPersonDetailsEntity?> findById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM login_person_details WHERE id = ?1',
        mapper: (Map<String, Object?> row) => LoginPersonDetailsEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            userPhone: row['userPhone'] as String,
            dob: row['dob'] as String?,
            bloodGroup: row['bloodGroup'] as String?,
            designation: row['designation'] as String?,
            type: row['type'] as String?,
            recordStatus: row['recordStatus'] as int,
            updatedAt: row['updatedAt'] as String,
            userId: row['userId'] as String?,
            userEmail: row['userEmail'] as String?,
            organizationId: row['organizationId'] as String?,
            organizationName: row['organizationName'] as String?,
            departmentId: row['departmentId'] as String?,
            departmentName: row['departmentName'] as String?,
            managerId: row['managerId'] as String?,
            managerName: row['managerName'] as String?,
            managerContact: row['managerContact'] as String?,
            shiftId: row['shiftId'] as String?,
            shiftName: row['shiftName'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<LoginPersonDetailsEntity>> getAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM login_person_details',
        mapper: (Map<String, Object?> row) => LoginPersonDetailsEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            userPhone: row['userPhone'] as String,
            dob: row['dob'] as String?,
            bloodGroup: row['bloodGroup'] as String?,
            designation: row['designation'] as String?,
            type: row['type'] as String?,
            recordStatus: row['recordStatus'] as int,
            updatedAt: row['updatedAt'] as String,
            userId: row['userId'] as String?,
            userEmail: row['userEmail'] as String?,
            organizationId: row['organizationId'] as String?,
            organizationName: row['organizationName'] as String?,
            departmentId: row['departmentId'] as String?,
            departmentName: row['departmentName'] as String?,
            managerId: row['managerId'] as String?,
            managerName: row['managerName'] as String?,
            managerContact: row['managerContact'] as String?,
            shiftId: row['shiftId'] as String?,
            shiftName: row['shiftName'] as String?));
  }

  @override
  Future<void> clearAllPersons() async {
    await _queryAdapter.queryNoReturn('DELETE FROM login_person_details');
  }

  @override
  Future<void> upsertPerson(LoginPersonDetailsEntity entity) async {
    await _loginPersonDetailsEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }
}

class _$LoginPersonContactDao extends LoginPersonContactDao {
  _$LoginPersonContactDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _loginPersonContactEntityInsertionAdapter = InsertionAdapter(
            database,
            'login_person_contact',
            (LoginPersonContactEntity item) => <String, Object?>{
                  'id': item.id,
                  'label': item.label,
                  'relationship': item.relationship,
                  'phone': item.phone,
                  'email': item.email,
                  'recordStatus': item.recordStatus,
                  'updatedAt': item.updatedAt,
                  'personId': item.personId,
                  'personName': item.personName,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginPersonContactEntity>
      _loginPersonContactEntityInsertionAdapter;

  @override
  Future<List<LoginPersonContactEntity>> getContactsForPerson(
      String personId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM login_person_contact WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => LoginPersonContactEntity(
            id: row['id'] as String,
            label: row['label'] as String,
            relationship: row['relationship'] as String?,
            phone: row['phone'] as String?,
            email: row['email'] as String?,
            recordStatus: row['recordStatus'] as int,
            updatedAt: row['updatedAt'] as String,
            personId: row['personId'] as String,
            personName: row['personName'] as String,
            name: row['name'] as String),
        arguments: [personId]);
  }

  @override
  Future<void> deleteContactsForPerson(String personId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM login_person_contact WHERE personId = ?1',
        arguments: [personId]);
  }

  @override
  Future<void> upsertContacts(List<LoginPersonContactEntity> entities) async {
    await _loginPersonContactEntityInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }
}

class _$LoginPersonAttendanceDao extends LoginPersonAttendanceDao {
  _$LoginPersonAttendanceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _loginPersonAttendanceEntityInsertionAdapter = InsertionAdapter(
            database,
            'login_person_attendance',
            (LoginPersonAttendanceEntity item) => <String, Object?>{
                  'id': item.id,
                  'attDate': item.attDate,
                  'checkIn': item.checkIn,
                  'checkOut': item.checkOut,
                  'remarks': item.remarks,
                  'status': item.status,
                  'recordStatus': item.recordStatus,
                  'updatedAt': item.updatedAt,
                  'personId': item.personId,
                  'personName': item.personName,
                  'shiftId': item.shiftId,
                  'shiftName': item.shiftName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginPersonAttendanceEntity>
      _loginPersonAttendanceEntityInsertionAdapter;

  @override
  Future<List<LoginPersonAttendanceEntity>> getAttendanceForPerson(
      String personId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM login_person_attendance WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => LoginPersonAttendanceEntity(
            id: row['id'] as String,
            attDate: row['attDate'] as String,
            checkIn: row['checkIn'] as String?,
            checkOut: row['checkOut'] as String?,
            remarks: row['remarks'] as String?,
            status: row['status'] as String,
            recordStatus: row['recordStatus'] as int,
            updatedAt: row['updatedAt'] as String,
            personId: row['personId'] as String,
            personName: row['personName'] as String,
            shiftId: row['shiftId'] as String?,
            shiftName: row['shiftName'] as String?),
        arguments: [personId]);
  }

  @override
  Future<void> deleteAttendanceForPerson(String personId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM login_person_attendance WHERE personId = ?1',
        arguments: [personId]);
  }

  @override
  Future<void> upsertAttendance(
      List<LoginPersonAttendanceEntity> entities) async {
    await _loginPersonAttendanceEntityInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }
}

class _$LoginPersonAssetDao extends LoginPersonAssetDao {
  _$LoginPersonAssetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _loginPersonAssetEntityInsertionAdapter = InsertionAdapter(
            database,
            'login_person_assets',
            (LoginPersonAssetEntity item) => <String, Object?>{
                  'id': item.id,
                  'recordStatus': item.recordStatus,
                  'createdAt': item.createdAt,
                  'personId': item.personId,
                  'personName': item.personName,
                  'assetId': item.assetId,
                  'assetName': item.assetName,
                  'assetSerialNumber': item.assetSerialNumber
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginPersonAssetEntity>
      _loginPersonAssetEntityInsertionAdapter;

  @override
  Future<List<LoginPersonAssetEntity>> getAssetForPerson(
      String personId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM login_person_assets WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => LoginPersonAssetEntity(
            id: row['id'] as String,
            recordStatus: row['recordStatus'] as int,
            personId: row['personId'] as String?,
            createdAt: row['createdAt'] as String?,
            personName: row['personName'] as String?,
            assetId: row['assetId'] as String?,
            assetName: row['assetName'] as String?,
            assetSerialNumber: row['assetSerialNumber'] as String?),
        arguments: [personId]);
  }

  @override
  Future<void> deleteAssetForPerson(String personId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM login_person_assets WHERE personId = ?1',
        arguments: [personId]);
  }

  @override
  Future<void> upsertAssets(List<LoginPersonAssetEntity> entities) async {
    await _loginPersonAssetEntityInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
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
                  'lookupType': item.lookupType,
                  'sortOrder': item.sortOrder,
                  'recordStatus': item.recordStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LookupEntity> _lookupEntityInsertionAdapter;

  @override
  Future<List<LookupEntity>> getActiveByType(LookupType lookupType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM lookup     WHERE lookupType = ?1       AND recordStatus = 1     ORDER BY sortOrder',
        mapper: (Map<String, Object?> row) => LookupEntity(id: row['id'] as String, code: row['code'] as String, displayName: row['displayName'] as String, lookupType: row['lookupType'] as String, sortOrder: row['sortOrder'] as int, recordStatus: row['recordStatus'] as int),
        arguments: [_lookupTypeConverter.encode(lookupType)]);
  }

  @override
  Future<List<LookupEntity>> getActiveByCode(String lookupCode) async {
    return _queryAdapter.queryList(
        'SELECT * FROM lookup     WHERE code = ?1       AND recordStatus = 1     ORDER BY sortOrder',
        mapper: (Map<String, Object?> row) => LookupEntity(id: row['id'] as String, code: row['code'] as String, displayName: row['displayName'] as String, lookupType: row['lookupType'] as String, sortOrder: row['sortOrder'] as int, recordStatus: row['recordStatus'] as int),
        arguments: [lookupCode]);
  }

  @override
  Future<List<LookupEntity>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM lookup ORDER BY sortOrder',
        mapper: (Map<String, Object?> row) => LookupEntity(
            id: row['id'] as String,
            code: row['code'] as String,
            displayName: row['displayName'] as String,
            lookupType: row['lookupType'] as String,
            sortOrder: row['sortOrder'] as int,
            recordStatus: row['recordStatus'] as int));
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
                  'plantName': item.plantName
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
            plantName: row['plantName'] as String?));
  }

  @override
  Future<AssetEntity?> getAsset(String serialNo) async {
    return _queryAdapter.query(
        'SELECT * FROM assets WHERE serialNumber = ?1 LIMIT 1',
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
            plantName: row['plantName'] as String?),
        arguments: [serialNo]);
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

class _$PlantsOrgDao extends PlantsOrgDao {
  _$PlantsOrgDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _plantsOrgEntityInsertionAdapter = InsertionAdapter(
            database,
            'plants_org',
            (PlantsOrgEntity item) => <String, Object?>{
                  'id': item.id,
                  'displayName': item.displayName,
                  'orgTypeId': item.orgTypeId,
                  'orgTypeName': item.orgTypeName,
                  'addressLine1': item.addressLine1,
                  'addressLine2': item.addressLine2,
                  'zip': item.zip,
                  'recordStatus': item.recordStatus,
                  'tenantId': item.tenantId,
                  'tenantName': item.tenantName,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                  'parentOrgId': item.parentOrgId,
                  'parentOrgName': item.parentOrgName,
                  'countryId': item.countryId,
                  'countryName': item.countryName,
                  'stateId': item.stateId,
                  'stateName': item.stateName,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'timezoneId': item.timezoneId,
                  'timezoneName': item.timezoneName,
                  'dateFormatId': item.dateFormatId,
                  'languageId': item.languageId,
                  'languageName': item.languageName,
                  'currencyId': item.currencyId,
                  'currencyName': item.currencyName,
                  'taxProfileId': item.taxProfileId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlantsOrgEntity> _plantsOrgEntityInsertionAdapter;

  @override
  Future<List<PlantsOrgEntity>> getActivePlants() async {
    return _queryAdapter.queryList(
        'SELECT * FROM plants_org      WHERE recordStatus = 1      ORDER BY displayName',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(
            id: row['id'] as String,
            displayName: row['displayName'] as String,
            orgTypeId: row['orgTypeId'] as String,
            orgTypeName: row['orgTypeName'] as String,
            addressLine1: row['addressLine1'] as String,
            addressLine2: row['addressLine2'] as String,
            zip: row['zip'] as String,
            recordStatus: row['recordStatus'] as int,
            tenantId: row['tenantId'] as String,
            tenantName: row['tenantName'] as String,
            clientId: row['clientId'] as String,
            clientName: row['clientName'] as String,
            parentOrgId: row['parentOrgId'] as String?,
            parentOrgName: row['parentOrgName'] as String?,
            countryId: row['countryId'] as String,
            countryName: row['countryName'] as String,
            stateId: row['stateId'] as String,
            stateName: row['stateName'] as String,
            districtId: row['districtId'] as String,
            districtName: row['districtName'] as String,
            timezoneId: row['timezoneId'] as String,
            timezoneName: row['timezoneName'] as String,
            dateFormatId: row['dateFormatId'] as String,
            languageId: row['languageId'] as String,
            languageName: row['languageName'] as String,
            currencyId: row['currencyId'] as String,
            currencyName: row['currencyName'] as String,
            taxProfileId: row['taxProfileId'] as String?));
  }

  @override
  Future<List<PlantsOrgEntity>> getActiveByTenant(String tenantId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM plants_org      WHERE tenantId = ?1        AND recordStatus = 1      ORDER BY displayName',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(id: row['id'] as String, displayName: row['displayName'] as String, orgTypeId: row['orgTypeId'] as String, orgTypeName: row['orgTypeName'] as String, addressLine1: row['addressLine1'] as String, addressLine2: row['addressLine2'] as String, zip: row['zip'] as String, recordStatus: row['recordStatus'] as int, tenantId: row['tenantId'] as String, tenantName: row['tenantName'] as String, clientId: row['clientId'] as String, clientName: row['clientName'] as String, parentOrgId: row['parentOrgId'] as String?, parentOrgName: row['parentOrgName'] as String?, countryId: row['countryId'] as String, countryName: row['countryName'] as String, stateId: row['stateId'] as String, stateName: row['stateName'] as String, districtId: row['districtId'] as String, districtName: row['districtName'] as String, timezoneId: row['timezoneId'] as String, timezoneName: row['timezoneName'] as String, dateFormatId: row['dateFormatId'] as String, languageId: row['languageId'] as String, languageName: row['languageName'] as String, currencyId: row['currencyId'] as String, currencyName: row['currencyName'] as String, taxProfileId: row['taxProfileId'] as String?),
        arguments: [tenantId]);
  }

  @override
  Future<List<PlantsOrgEntity>> getActiveByClient(String clientId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM plants_org      WHERE clientId = ?1        AND recordStatus = 1      ORDER BY displayName',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(id: row['id'] as String, displayName: row['displayName'] as String, orgTypeId: row['orgTypeId'] as String, orgTypeName: row['orgTypeName'] as String, addressLine1: row['addressLine1'] as String, addressLine2: row['addressLine2'] as String, zip: row['zip'] as String, recordStatus: row['recordStatus'] as int, tenantId: row['tenantId'] as String, tenantName: row['tenantName'] as String, clientId: row['clientId'] as String, clientName: row['clientName'] as String, parentOrgId: row['parentOrgId'] as String?, parentOrgName: row['parentOrgName'] as String?, countryId: row['countryId'] as String, countryName: row['countryName'] as String, stateId: row['stateId'] as String, stateName: row['stateName'] as String, districtId: row['districtId'] as String, districtName: row['districtName'] as String, timezoneId: row['timezoneId'] as String, timezoneName: row['timezoneName'] as String, dateFormatId: row['dateFormatId'] as String, languageId: row['languageId'] as String, languageName: row['languageName'] as String, currencyId: row['currencyId'] as String, currencyName: row['currencyName'] as String, taxProfileId: row['taxProfileId'] as String?),
        arguments: [clientId]);
  }

  @override
  Future<List<PlantsOrgEntity>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM plants_org ORDER BY displayName',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(
            id: row['id'] as String,
            displayName: row['displayName'] as String,
            orgTypeId: row['orgTypeId'] as String,
            orgTypeName: row['orgTypeName'] as String,
            addressLine1: row['addressLine1'] as String,
            addressLine2: row['addressLine2'] as String,
            zip: row['zip'] as String,
            recordStatus: row['recordStatus'] as int,
            tenantId: row['tenantId'] as String,
            tenantName: row['tenantName'] as String,
            clientId: row['clientId'] as String,
            clientName: row['clientName'] as String,
            parentOrgId: row['parentOrgId'] as String?,
            parentOrgName: row['parentOrgName'] as String?,
            countryId: row['countryId'] as String,
            countryName: row['countryName'] as String,
            stateId: row['stateId'] as String,
            stateName: row['stateName'] as String,
            districtId: row['districtId'] as String,
            districtName: row['districtName'] as String,
            timezoneId: row['timezoneId'] as String,
            timezoneName: row['timezoneName'] as String,
            dateFormatId: row['dateFormatId'] as String,
            languageId: row['languageId'] as String,
            languageName: row['languageName'] as String,
            currencyId: row['currencyId'] as String,
            currencyName: row['currencyName'] as String,
            taxProfileId: row['taxProfileId'] as String?));
  }

  @override
  Future<PlantsOrgEntity?> getById(String id) async {
    return _queryAdapter.query('SELECT * FROM plants_org WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(
            id: row['id'] as String,
            displayName: row['displayName'] as String,
            orgTypeId: row['orgTypeId'] as String,
            orgTypeName: row['orgTypeName'] as String,
            addressLine1: row['addressLine1'] as String,
            addressLine2: row['addressLine2'] as String,
            zip: row['zip'] as String,
            recordStatus: row['recordStatus'] as int,
            tenantId: row['tenantId'] as String,
            tenantName: row['tenantName'] as String,
            clientId: row['clientId'] as String,
            clientName: row['clientName'] as String,
            parentOrgId: row['parentOrgId'] as String?,
            parentOrgName: row['parentOrgName'] as String?,
            countryId: row['countryId'] as String,
            countryName: row['countryName'] as String,
            stateId: row['stateId'] as String,
            stateName: row['stateName'] as String,
            districtId: row['districtId'] as String,
            districtName: row['districtName'] as String,
            timezoneId: row['timezoneId'] as String,
            timezoneName: row['timezoneName'] as String,
            dateFormatId: row['dateFormatId'] as String,
            languageId: row['languageId'] as String,
            languageName: row['languageName'] as String,
            currencyId: row['currencyId'] as String,
            currencyName: row['currencyName'] as String,
            taxProfileId: row['taxProfileId'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<PlantsOrgEntity>> searchPlants(String searchTerm) async {
    return _queryAdapter.queryList(
        'SELECT * FROM plants_org WHERE displayName LIKE ?1 AND recordStatus = 1',
        mapper: (Map<String, Object?> row) => PlantsOrgEntity(id: row['id'] as String, displayName: row['displayName'] as String, orgTypeId: row['orgTypeId'] as String, orgTypeName: row['orgTypeName'] as String, addressLine1: row['addressLine1'] as String, addressLine2: row['addressLine2'] as String, zip: row['zip'] as String, recordStatus: row['recordStatus'] as int, tenantId: row['tenantId'] as String, tenantName: row['tenantName'] as String, clientId: row['clientId'] as String, clientName: row['clientName'] as String, parentOrgId: row['parentOrgId'] as String?, parentOrgName: row['parentOrgName'] as String?, countryId: row['countryId'] as String, countryName: row['countryName'] as String, stateId: row['stateId'] as String, stateName: row['stateName'] as String, districtId: row['districtId'] as String, districtName: row['districtName'] as String, timezoneId: row['timezoneId'] as String, timezoneName: row['timezoneName'] as String, dateFormatId: row['dateFormatId'] as String, languageId: row['languageId'] as String, languageName: row['languageName'] as String, currencyId: row['currencyId'] as String, currencyName: row['currencyName'] as String, taxProfileId: row['taxProfileId'] as String?),
        arguments: [searchTerm]);
  }

  @override
  Future<void> deletePlant(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM plants_org WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM plants_org');
  }

  @override
  Future<void> upsertAll(List<PlantsOrgEntity> rows) async {
    await _plantsOrgEntityInsertionAdapter.insertList(
        rows, OnConflictStrategy.replace);
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
                  'operatorName': item.operatorName,
                  'operatorId': item.operatorId,
                  'operatorPhoneNumber': item.operatorPhoneNumber,
                  'categoryId': item.categoryId,
                  'categoryName': item.categoryName,
                  'reporterId': item.reporterId,
                  'reporterName': item.reporterName,
                  'reporterPhoneNumber': item.reporterPhoneNumber,
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
                  'operatorName': item.operatorName,
                  'operatorId': item.operatorId,
                  'operatorPhoneNumber': item.operatorPhoneNumber,
                  'categoryId': item.categoryId,
                  'categoryName': item.categoryName,
                  'reporterId': item.reporterId,
                  'reporterName': item.reporterName,
                  'reporterPhoneNumber': item.reporterPhoneNumber,
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
            operatorId: row['operatorId'] as String,
            operatorName: row['operatorName'] as String,
            operatorPhoneNumber: row['operatorPhoneNumber'] as String,
            categoryId: row['categoryId'] as String,
            categoryName: row['categoryName'] as String,
            reporterId: row['reporterId'] as String,
            reporterName: row['reporterName'] as String,
            reporterPhoneNumber: row['reporterPhoneNumber'] as String,
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

class _$OperatorsDetailsDao extends OperatorsDetailsDao {
  _$OperatorsDetailsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _operatorsDetailsEntityInsertionAdapter = InsertionAdapter(
            database,
            'operators_details_entity',
            (OperatorsDetailsEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'userPhone': item.userPhone,
                  'dob': _epochDateTimeConverter.encode(item.dob),
                  'updatedAt': _epochDateTimeConverter.encode(item.updatedAt),
                  'bloodGroup': item.bloodGroup,
                  'designation': item.designation,
                  'type': item.type,
                  'recordStatus': item.recordStatus,
                  'tenantId': item.tenantId,
                  'clientId': item.clientId,
                  'userId': item.userId,
                  'organizationId': item.organizationId,
                  'parentStaffId': item.parentStaffId,
                  'managerId': item.managerId,
                  'shiftId': item.shiftId,
                  'departmentId': item.departmentId,
                  'userEmail': item.userEmail,
                  'organizationName': item.organizationName,
                  'parentStaffName': item.parentStaffName,
                  'managerName': item.managerName,
                  'shiftName': item.shiftName,
                  'departmentName': item.departmentName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OperatorsDetailsEntity>
      _operatorsDetailsEntityInsertionAdapter;

  @override
  Future<List<OperatorsDetailsEntity>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM operators_details_entity ORDER BY name COLLATE NOCASE ASC',
        mapper: (Map<String, Object?> row) => OperatorsDetailsEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            userPhone: row['userPhone'] as String,
            type: row['type'] as String,
            recordStatus: row['recordStatus'] as int,
            tenantId: row['tenantId'] as String,
            clientId: row['clientId'] as String,
            dob: _epochDateTimeConverter.decode(row['dob'] as int?),
            updatedAt: _epochDateTimeConverter.decode(row['updatedAt'] as int?),
            bloodGroup: row['bloodGroup'] as String?,
            designation: row['designation'] as String?,
            userId: row['userId'] as String?,
            organizationId: row['organizationId'] as String?,
            parentStaffId: row['parentStaffId'] as String?,
            managerId: row['managerId'] as String?,
            shiftId: row['shiftId'] as String?,
            departmentId: row['departmentId'] as String?,
            userEmail: row['userEmail'] as String?,
            organizationName: row['organizationName'] as String?,
            parentStaffName: row['parentStaffName'] as String?,
            managerName: row['managerName'] as String?,
            shiftName: row['shiftName'] as String?,
            departmentName: row['departmentName'] as String?));
  }

  @override
  Future<void> upsertAll(List<OperatorsDetailsEntity> items) async {
    await _operatorsDetailsEntityInsertionAdapter.insertList(
        items, OnConflictStrategy.replace);
  }
}

class _$LoginPersonHolidaysDao extends LoginPersonHolidaysDao {
  _$LoginPersonHolidaysDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _loginPersonHolidayEntityInsertionAdapter = InsertionAdapter(
            database,
            'login_person_holidays',
            (LoginPersonHolidayEntity item) => <String, Object?>{
                  'id': item.id,
                  'holidayDate':
                      _epochDateTimeConverter.encode(item.holidayDate),
                  'holidayName': item.holidayName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginPersonHolidayEntity>
      _loginPersonHolidayEntityInsertionAdapter;

  @override
  Future<List<LoginPersonHolidayEntity>> getAllHolidays() async {
    return _queryAdapter.queryList(
        'SELECT * FROM login_person_holidays ORDER BY holidayDate ASC',
        mapper: (Map<String, Object?> row) => LoginPersonHolidayEntity(
            id: row['id'] as String,
            holidayDate:
                _epochDateTimeConverter.decode(row['holidayDate'] as int?),
            holidayName: row['holidayName'] as String?));
  }

  @override
  Future<LoginPersonHolidayEntity?> findByExactDate(DateTime date) async {
    return _queryAdapter.query(
        'SELECT * FROM login_person_holidays WHERE holidayDate = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => LoginPersonHolidayEntity(
            id: row['id'] as String,
            holidayDate:
                _epochDateTimeConverter.decode(row['holidayDate'] as int?),
            holidayName: row['holidayName'] as String?),
        arguments: [_dateTimeIsoConverter.encode(date)]);
  }

  @override
  Future<List<LoginPersonHolidayEntity>> findBetween(
    DateTime from,
    DateTime to,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM login_person_holidays WHERE holidayDate >= ?1 AND holidayDate <= ?2 ORDER BY holidayDate ASC',
        mapper: (Map<String, Object?> row) => LoginPersonHolidayEntity(id: row['id'] as String, holidayDate: _epochDateTimeConverter.decode(row['holidayDate'] as int?), holidayName: row['holidayName'] as String?),
        arguments: [
          _dateTimeIsoConverter.encode(from),
          _dateTimeIsoConverter.encode(to)
        ]);
  }

  @override
  Future<void> deleteAllHolidays() async {
    await _queryAdapter.queryNoReturn('DELETE FROM login_person_holidays');
  }

  @override
  Future<void> upsertPersonHolidays(
      List<LoginPersonHolidayEntity> entities) async {
    await _loginPersonHolidayEntityInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }
}

class _$UserListDao extends UserListDao {
  _$UserListDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userListEntityInsertionAdapter = InsertionAdapter(
            database,
            'users_list',
            (UserListEntity item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'communicationEmail': item.communicationEmail,
                  'passwordHash': item.passwordHash,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'phone': item.phone,
                  'userType': _userTypeConverter.encode(item.userType),
                  'recordStatus': item.recordStatus,
                  'createdAt': _dateTimeIsoConverter.encode(item.createdAt),
                  'updatedAt': _dateTimeIsoConverter.encode(item.updatedAt),
                  'tenantId': item.tenantId,
                  'tenantName': item.tenantName,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                  'orgId': item.orgId,
                  'orgName': item.orgName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserListEntity> _userListEntityInsertionAdapter;

  @override
  Future<List<UserListEntity>> getAllUsers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM users_list ORDER BY updatedAt DESC',
        mapper: (Map<String, Object?> row) => UserListEntity(
            id: row['id'] as String,
            email: row['email'] as String,
            communicationEmail: row['communicationEmail'] as String?,
            passwordHash: row['passwordHash'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            phone: row['phone'] as String,
            userType: _userTypeConverter.decode(row['userType'] as String),
            recordStatus: row['recordStatus'] as int,
            createdAt: _dateTimeIsoConverter.decode(row['createdAt'] as String),
            updatedAt: _dateTimeIsoConverter.decode(row['updatedAt'] as String),
            tenantId: row['tenantId'] as String,
            tenantName: row['tenantName'] as String,
            clientId: row['clientId'] as String,
            clientName: row['clientName'] as String,
            orgId: row['orgId'] as String?,
            orgName: row['orgName'] as String?));
  }

  @override
  Future<void> upsertUsers(List<UserListEntity> users) async {
    await _userListEntityInsertionAdapter.insertList(
        users, OnConflictStrategy.replace);
  }
}

class _$OrganizationDao extends OrganizationDao {
  _$OrganizationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _organizationEntityInsertionAdapter = InsertionAdapter(
            database,
            'organizations',
            (OrganizationEntity item) => <String, Object?>{
                  'id': item.id,
                  'displayName': item.displayName,
                  'orgTypeId': item.orgTypeId,
                  'orgTypeName': item.orgTypeName,
                  'addressLine1': item.addressLine1,
                  'addressLine2': item.addressLine2,
                  'zip': item.zip,
                  'recordStatus': item.recordStatus,
                  'tenantId': item.tenantId,
                  'tenantName': item.tenantName,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                  'parentOrgId': item.parentOrgId,
                  'parentOrgName': item.parentOrgName,
                  'countryId': item.countryId,
                  'countryName': item.countryName,
                  'stateId': item.stateId,
                  'stateName': item.stateName,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'timezoneId': item.timezoneId,
                  'timezoneName': item.timezoneName,
                  'dateFormatId': item.dateFormatId,
                  'languageId': item.languageId,
                  'languageName': item.languageName,
                  'currencyId': item.currencyId,
                  'currencyName': item.currencyName,
                  'taxProfileId': item.taxProfileId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrganizationEntity>
      _organizationEntityInsertionAdapter;

  @override
  Future<List<OrganizationEntity>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM organizations ORDER BY displayName',
        mapper: (Map<String, Object?> row) => OrganizationEntity(
            id: row['id'] as String,
            displayName: row['displayName'] as String,
            orgTypeId: row['orgTypeId'] as String?,
            orgTypeName: row['orgTypeName'] as String?,
            addressLine1: row['addressLine1'] as String?,
            addressLine2: row['addressLine2'] as String?,
            zip: row['zip'] as String?,
            recordStatus: row['recordStatus'] as int?,
            tenantId: row['tenantId'] as String?,
            tenantName: row['tenantName'] as String?,
            clientId: row['clientId'] as String?,
            clientName: row['clientName'] as String?,
            parentOrgId: row['parentOrgId'] as String?,
            parentOrgName: row['parentOrgName'] as String?,
            countryId: row['countryId'] as String?,
            countryName: row['countryName'] as String?,
            stateId: row['stateId'] as String?,
            stateName: row['stateName'] as String?,
            districtId: row['districtId'] as String?,
            districtName: row['districtName'] as String?,
            timezoneId: row['timezoneId'] as String?,
            timezoneName: row['timezoneName'] as String?,
            dateFormatId: row['dateFormatId'] as String?,
            languageId: row['languageId'] as String?,
            languageName: row['languageName'] as String?,
            currencyId: row['currencyId'] as String?,
            currencyName: row['currencyName'] as String?,
            taxProfileId: row['taxProfileId'] as String?));
  }

  @override
  Future<void> upsertAll(List<OrganizationEntity> rows) async {
    await _organizationEntityInsertionAdapter.insertList(
        rows, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _epochDateTimeConverter = EpochDateTimeConverter();
final _lookupTypeConverter = LookupTypeConverter();
final _dateTimeIsoConverter = DateTimeIsoConverter();
final _criticalityConverter = CriticalityConverter();
final _assetStatusConverter = AssetStatusConverter();
final _dateTimeConverter = DateTimeConverter();
final _userTypeConverter = UserTypeConverter();
