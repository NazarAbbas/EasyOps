// lib/database/entity/organization_entity.dart
import 'package:floor/floor.dart';

@Entity(
  tableName: 'organizations',
  indices: [
    Index(value: ['tenantId', 'clientId', 'displayName'], unique: true),
    Index(value: ['tenantId', 'clientId']),
    Index(value: ['parentOrgId']),
    Index(value: ['recordStatus']),
  ],
)
class OrganizationEntity {
  @primaryKey
  final String id;

  final String displayName;

  final String? orgTypeId;
  final String? orgTypeName;

  final String? addressLine1;
  final String? addressLine2;
  final String? zip;

  final int? recordStatus;

  final String? tenantId;
  final String? tenantName;

  final String? clientId;
  final String? clientName;

  final String? parentOrgId;
  final String? parentOrgName;

  final String? countryId;
  final String? countryName;

  final String? stateId;
  final String? stateName;

  final String? districtId;
  final String? districtName;

  final String? timezoneId;
  final String? timezoneName;

  final String? dateFormatId;

  final String? languageId;
  final String? languageName;

  final String? currencyId;
  final String? currencyName;

  final String? taxProfileId;

  const OrganizationEntity({
    required this.id,
    required this.displayName,
    this.orgTypeId,
    this.orgTypeName,
    this.addressLine1,
    this.addressLine2,
    this.zip,
    this.recordStatus,
    this.tenantId,
    this.tenantName,
    this.clientId,
    this.clientName,
    this.parentOrgId,
    this.parentOrgName,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.districtId,
    this.districtName,
    this.timezoneId,
    this.timezoneName,
    this.dateFormatId,
    this.languageId,
    this.languageName,
    this.currencyId,
    this.currencyName,
    this.taxProfileId,
  });
}
