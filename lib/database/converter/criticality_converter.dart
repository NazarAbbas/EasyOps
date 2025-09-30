// lib/database/converter/asset_converters.dart
import 'package:floor/floor.dart';

enum Criticality { LOW, MEDIUM, HIGH }

enum AssetStatus { ACTIVE, INACTIVE }

class CriticalityConverter extends TypeConverter<Criticality, String> {
  @override
  Criticality decode(String databaseValue) => Criticality.values.firstWhere(
        (e) => e.name.toUpperCase() == databaseValue.toUpperCase(),
        orElse: () => Criticality.MEDIUM,
      );

  @override
  String encode(Criticality value) => value.name;
}

class AssetStatusConverter extends TypeConverter<AssetStatus, String> {
  @override
  AssetStatus decode(String databaseValue) => AssetStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == databaseValue.toUpperCase(),
        orElse: () => AssetStatus.ACTIVE,
      );

  @override
  String encode(AssetStatus value) => value.name;
}
