import 'package:floor/floor.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM user')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM user WHERE iSocietyWingId = :iSocietyWingId')
  Future<List<User>> findWingAllUsers(int iSocietyWingId);

  @Query('SELECT * FROM user WHERE iUserId = :iUserId')
  Future<User?> findUserById(int iUserId);

  @insert
  Future<void> insertUser(User user);

  @insert
  Future<void> insertUserMultiple(List<User> users);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}