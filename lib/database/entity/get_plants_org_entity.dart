// lib/database/entity/plants_org_entity.dart
import 'package:easy_ops/database/converter/converters.dart';
import 'package:floor/floor.dart';

@TypeConverters([LookupTypeConverter, DateTimeIsoConverter])
@Entity(
  tableName: 'plants_org',
  indices: [
    // Fast filtering by tenant/client/type, and unique on code inside that scope.
    Index(value: ['orgTypeId']),
    Index(value: ['orgTypeId', 'id']),
  ],
)
class PlantsOrgEntity {
  @primaryKey
  final String id;

  final String displayName;
  final String orgTypeId;
  final String orgTypeName;
  final String addressLine1;
  final String addressLine2;
  final String zip;
  final int recordStatus;
  final String tenantId;
  final String tenantName;
  final String clientId;
  final String clientName;
  final String? parentOrgId;
  final String? parentOrgName;
  final String countryId;
  final String countryName;
  final String stateId;
  final String stateName;
  final String districtId;
  final String districtName;
  final String timezoneId;
  final String timezoneName;
  final String dateFormatId;
  final String languageId;
  final String languageName;
  final String currencyId;
  final String currencyName;
  final String? taxProfileId;

  const PlantsOrgEntity({
    required this.id,
    required this.displayName,
    required this.orgTypeId,
    required this.orgTypeName,
    required this.addressLine1,
    required this.addressLine2,
    required this.zip,
    required this.recordStatus,
    required this.tenantId,
    required this.tenantName,
    required this.clientId,
    required this.clientName,
    this.parentOrgId,
    this.parentOrgName,
    required this.countryId,
    required this.countryName,
    required this.stateId,
    required this.stateName,
    required this.districtId,
    required this.districtName,
    required this.timezoneId,
    required this.timezoneName,
    required this.dateFormatId,
    required this.languageId,
    required this.languageName,
    required this.currencyId,
    required this.currencyName,
    this.taxProfileId,
  });
}