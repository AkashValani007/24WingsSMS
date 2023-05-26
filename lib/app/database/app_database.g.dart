part of 'app_database.dart';

class $FloorAppDatabase {
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

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

  UserDao? _userDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `user` (`iUserId` INTEGER PRIMARY KEY, `vUserName` TEXT, `vMobile` TEXT, `vEmail` TEXT, `vHouseNo` INTEGER,`vBusinessName` TEXT, `vBusinessAddress` TEXT, `iMobilePrivacy` INTEGER, `iAddressPrivacy` INTEGER, `iSocietyWingId` INTEGER, `village` TEXT)');
        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  final StreamController<String> changeListener;
  final sqflite.DatabaseExecutor database;
  final QueryAdapter _queryAdapter;
  final InsertionAdapter<User> _taskInsertionAdapter;
  final UpdateAdapter<User> _taskUpdateAdapter;
  final DeletionAdapter<User> _taskDeletionAdapter;

  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (User item) => <String, Object?>{
                  'iUserId': item.iUserId,
                  'vUserName': item.vUserName,
                  'vMobile': item.vMobile,
                  'vEmail': item.vEmail,
                  'vHouseNo': item.vHouseNo,
                  'vBusinessName': item.vBusinessName,
                  'vBusinessAddress': item.vBusinessAddress,
                  'iMobilePrivacy': item.iMobilePrivacy,
                  'iAddressPrivacy': item.iAddressPrivacy,
                  'iSocietyWingId': item.iSocietyWingId,
                  'village': jsonEncode(item.village),
                },
            changeListener),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'user',
            ['iUserId'],
            (User item) => <String, Object?>{
                  'iUserId': item.iUserId,
                  'vUserName': item.vUserName,
                  'vMobile': item.vMobile,
                  'vEmail': item.vEmail,
                  'vHouseNo': item.vHouseNo,
                  'vBusinessName': item.vBusinessName,
                  'vBusinessAddress': item.vBusinessAddress,
                  'iMobilePrivacy': item.iMobilePrivacy,
                  'iAddressPrivacy': item.iAddressPrivacy,
                  'iSocietyWingId': item.iSocietyWingId,
                  'village': jsonEncode(item.village),
                },
            changeListener),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['iUserId'],
            (User item) => <String, Object?>{
                  'iUserId': item.iUserId,
                  'vUserName': item.vUserName,
                  'vMobile': item.vMobile,
                  'vEmail': item.vEmail,
                  'vHouseNo': item.vHouseNo,
                  'vBusinessName': item.vBusinessName,
                  'vBusinessAddress': item.vBusinessAddress,
                  'iMobilePrivacy': item.iMobilePrivacy,
                  'iAddressPrivacy': item.iAddressPrivacy,
                  'iSocietyWingId': item.iSocietyWingId,
                  'village': jsonEncode(item.village),
                },
            changeListener);

  @override
  Future<void> deleteUser(User user) async {
    await _taskDeletionAdapter.delete(user);
  }

  @override
  Future<List<User>> findAllUsers() {
    return _queryAdapter.queryList('SELECT * FROM user',
        mapper: (Map<String, Object?> row) => User(
              iUserId: row["iUserId"] as int?,
              vUserName: row["vUserName"] as String?,
              vMobile: row["vMobile"] as String?,
              vEmail: row["vEmail"] as String?,
              vHouseNo: row["vHouseNo"] as int?,
              vBusinessName: row["vBusinessName"] as String?,
              vBusinessAddress: row["vBusinessAddress"] as String?,
              iMobilePrivacy: row["iMobilePrivacy"] as int?,
              iAddressPrivacy: row["iAddressPrivacy"] as int?,
              iSocietyWingId: row["iSocietyWingId"] as int?,
              village: row["village"] != null
                  ? VillageData.fromJson(jsonDecode(row["village"] as String))
                  : null,
            ));
  }

  @override
  Future<List<User>> findWingAllUsers(int iSocietyWingId) {
    return _queryAdapter.queryList(
        'SELECT * FROM user WHERE iSocietyWingId = $iSocietyWingId',
        mapper: (Map<String, Object?> row) => User(
              iUserId: row["iUserId"] as int?,
              vUserName: row["vUserName"] as String?,
              vMobile: row["vMobile"] as String?,
              vEmail: row["vEmail"] as String?,
              vHouseNo: row["vHouseNo"] as int?,
              vBusinessName: row["vBusinessName"] as String?,
              vBusinessAddress: row["vBusinessAddress"] as String?,
              iMobilePrivacy: row["iMobilePrivacy"] as int?,
              iAddressPrivacy: row["iAddressPrivacy"] as int?,
              iSocietyWingId: row["iSocietyWingId"] as int?,
              village: row["village"] != null
                  ? VillageData.fromJson(jsonDecode(row["village"] as String))
                  : null,
            ));
  }

  @override
  Future<User?> findUserById(int iUserId) {
    return _queryAdapter.query('SELECT * FROM user WHERE iUserId = $iUserId',
        mapper: (Map<String, Object?> row) => User(
              iUserId: row["iUserId"] as int?,
              vUserName: row["vUserName"] as String?,
              vMobile: row["vMobile"] as String?,
              vEmail: row["vEmail"] as String?,
              vHouseNo: row["vHouseNo"] as int?,
              vBusinessName: row["vBusinessName"] as String?,
              vBusinessAddress: row["vBusinessAddress"] as String?,
              iMobilePrivacy: row["iMobilePrivacy"] as int?,
              iAddressPrivacy: row["iAddressPrivacy"] as int?,
              iSocietyWingId: row["iSocietyWingId"] as int?,
              village: row["village"] != null
                  ? VillageData.fromJson(jsonDecode(row["village"] as String))
                  : null,
            ));
  }

  @override
  Future<void> insertUser(User user) async {
    await _taskInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertUserMultiple(List<User> users) async {
    await _taskInsertionAdapter.insertList(users, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(User user) async {
    await _taskUpdateAdapter.update(user, OnConflictStrategy.replace);
  }
}
