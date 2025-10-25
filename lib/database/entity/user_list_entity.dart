import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:floor/floor.dart';

@TypeConverters([DateTimeConverter, UserTypeConverter])
@Entity(
  tableName: 'users_list',
)
class UserListEntity {
  @primaryKey
  final String id;

  final String email;
  final String? communicationEmail;
  final String passwordHash;
  final String firstName;
  final String lastName;
  final String phone;

  /// Stored via UserTypeConverter as String label
  final UserType userType;

  final int recordStatus; // 0/1/2
  final DateTime createdAt; // ISO via converter
  final DateTime updatedAt; // ISO via converter

  final String tenantId;
  final String tenantName;
  final String clientId;
  final String clientName;
  final String? orgId;
  final String? orgName;

  const UserListEntity({
    required this.id,
    required this.email,
    required this.communicationEmail,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.tenantId,
    required this.tenantName,
    required this.clientId,
    required this.clientName,
    required this.orgId,
    required this.orgName,
  });
}

// /// Optional: keep paging metadata (the last page we stored)
// @Entity(tableName: 'user_pages')
// class PageInfoEntity {
//   @primaryKey
//   final int number; // page number (key)
//   final int size;
//   final int totalElements;
//   final int totalPages;

//   const PageInfoEntity({
//     required this.number,
//     required this.size,
//     required this.totalElements,
//     required this.totalPages,
//   });
// }
