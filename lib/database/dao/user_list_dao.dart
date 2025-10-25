import 'package:easy_ops/database/entity/user_list_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserListDao {
  // ----- Write -----
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertUsers(List<UserListEntity> users);

  // --- Live streams (optional) ---
  @Query('SELECT * FROM users_list ORDER BY updatedAt DESC')
  Future<List<UserListEntity>> getAllUsers();
}
