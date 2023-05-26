import 'dart:async';
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:maintaince/app/database/dao/user_dao.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [User])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
