import 'package:easy_ops/database/converter/converters.dart';
import 'package:floor/floor.dart';
import '../../features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';

@TypeConverters([LookupTypeConverter, DateTimeIsoConverter])
@Entity(
  tableName: 'lookup',
  indices: [
    // Fast filtering by tenant/client/type, and unique on code inside that scope.
    Index(value: ['tenantId', 'clientId', 'lookupType']),
    Index(value: ['tenantId', 'clientId', 'lookupType', 'code'], unique: true),
  ],
)
class LookupEntity {
  @primaryKey
  final String id;

  final String code;
  final String displayName;
  final String description;

  // Stored via TypeConverter as TEXT (e.g., 'DEPARTMENT')
  final String lookupType;

  final int sortOrder;

  /// 1=active, 2=inactive, 0=deleted (as per your convention)
  final int recordStatus;

  // Stored via TypeConverter to ISO text
  final DateTime updatedAt;

  final String tenantId;
  final String clientId;

  const LookupEntity({
    required this.id,
    required this.code,
    required this.displayName,
    required this.description,
    required this.lookupType,
    required this.sortOrder,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
  });
}
