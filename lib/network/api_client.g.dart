part of 'api_client.dart';

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  Map<String, String> _header(bool isAccessRequired, {bool isAppJson = true}) {
    print(PreferenceManager.getString("token"));
    //final prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString("token");

    return isAccessRequired
        ? {
            'Authorization': 'Bearer ${PreferenceManager.getString("token")}',
            'Accept-Language': ' ${PreferenceManager.getString("vLanguage")}',
          }
        : {
            'Content-Type': 'application/json',
          };
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  @override
  Future<LoginResponse> login(
      {required String vMobile, required String vPassword}) async {
    final _data = {'vMobile': vMobile, 'vPassword': vPassword};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginResponse>(Options(
      method: 'POST',
    )
            .compose(_dio.options, LocaleKeys.login, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ConstantResponse> constant(String token) async {
    //final _header(true) = {'Authorization': "Bearer $token"};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ConstantResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.constant)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ConstantResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ConstantCityResponse> constantCity() async {
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ConstantCityResponse>(Options(method: 'GET')
            .compose(_dio.options, LocaleKeys.city)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ConstantCityResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WatchmenResponse> getWatchmen(String token,
      {required int iSocietyWingId}) async {
    final _data = {'iSocietyWingId': iSocietyWingId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WatchmenResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.watchmen, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WatchmenResponse.fromJson(_result.data!);
    return value;
  }

  // @override
  // Future<VehicleResponse> getVehicle(String token, {required int iUserWingId}) {
  //   // TODO: implement getVehicle
  //   throw UnimplementedError();
  // }

  @override
  Future<VehicleResponse> getVehicle(String token,
      {required int iSocietyWingId}) async {
    final _data = {'iSocietyWingId': iSocietyWingId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.vehicle, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserResponse> getUser(String token,
      {required int iSocietyWingId, required String timeStamp}) async {
    final _data = {'iSocietyWingId': iSocietyWingId, 'vTimestamp': timeStamp};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.getUser, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BalanceResponse> getBalance(String token,
      {required int iSocietyWingId}) async {
    final _data = {'iSocietyWingId': iSocietyWingId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BalanceResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.balance, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BalanceResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionResponse> getTransaction(String token,
      {required int iSocietyWingId,
      required String vStartDate,
      required String vEndDate,
      required int iType}) async {
    final _data = {
      'iSocietyWingId': iSocietyWingId,
      'vStartDate': vStartDate,
      'vEndDate': vEndDate,
      'iType': iType
    };
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TransactionResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.transaction,
                    queryParameters: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TransactionResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionResponse> getMyTransaction(String token,
      {required int iUserId}) async {
    final _data = {'iUserId': iUserId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TransactionResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.myTransaction,
                    queryParameters: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TransactionResponse.fromJson(_result.data!);
    return value;
  }

  // @override
  // Future<HouseResponse> getHouseList(String token,
  //     {required int iSocietyWingId}) async {
  //   final _data = {'iSocietyWingId': iSocietyWingId};
  //  //
  //   final _result = await _dio.fetch<Map<String, dynamic>>(
  //       _setStreamType<HouseResponse>(Options(method: 'GET', headers: _header(true))
  //           .compose(_dio.options, LocaleKeys.getHouseList,
  //               queryParameters: _data)
  //           .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = HouseResponse.fromJson(_result.data!);
  //   return value;
  // }

  @override
  Future<UserCreateResponse> createUser(String token,
      {required int iSocietyWingId,
      required int userTypes,
      required int isOwner,
      required int isCommitteeMember,
      required int iHouseId,
      required String name,
      required String number,
      required String vPassword,
      required String email,
      required String bName,
      required String bAddress}) async {
    //
    final _data = {
      'iSocietyWingId': iSocietyWingId,
      'iUserTypeId': userTypes,
      'isOwner': isOwner,
      'iHouseId': iHouseId,
      'vUserName': name,
      'vMobile': number,
      'vPassword': number,
      'vEmail': email,
      'vBusinessName': bName,
      'vBusinessAddress': bAddress
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.createUser, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserCreateResponse> updateUser(
    String token, {
    required int iUserId,
    required String name,
    required String number,
    required int iHouseId,
    required String email,
    required String bName,
    required int iSocietyWingId,
    required String bAddress,
    required int userTypes,
  }) async {
    //
    final _data = {
      'iUserId': iUserId,
      'vUserName': name,
      'vMobile': number,
      'vPassword': number,
      'iUserTypeId': userTypes,
      'vEmail': email,
      'iHouseId': iHouseId,
      'iSocietyWingId': iSocietyWingId,
      'vBusinessName': bName,
      'vBusinessAddress': bAddress
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.createUser, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserCreateResponse> editUser(
    String token, {
    required int iUserId,
    required String vUserName,
    required String vEmail,
    required int iGender,
    required String vBusinessName,
    required String vBusinessAddress,
    required String dtDOB,
  }) async {
    //
    final _data = {
      'iUserId': iUserId,
      'vUserName': vUserName,
      'vEmail': vEmail,
      'iGender': iGender,
      'vBusinessName': vBusinessName,
      'vBusinessAddress': vBusinessAddress,
      'dtDOB': dtDOB
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.createUser, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserCreateResponse> deleteUser(String token,
      {required int iUserId}) async {
    //
    final _data = {
      'iUserId': iUserId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserCreateResponse>(
            Options(method: 'DELETE', headers: _header(true))
                .compose(_dio.options, LocaleKeys.createUser, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WatchmenCreateResponse> deleteWatchmen(String token,
      {required int iWatchmenId}) async {
    //
    final _data = {
      'iWatchmenId': iWatchmenId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WatchmenCreateResponse>(
            Options(method: 'DELETE', headers: _header(true))
                .compose(_dio.options, LocaleKeys.watchmen, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WatchmenCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleCreateResponse> deleteVehicle(String token,
      {required int iVehicleId}) async {
    //
    final _data = {
      'iVehicleId': iVehicleId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleCreateResponse>(
            Options(method: 'DELETE', headers: _header(true))
                .compose(_dio.options, LocaleKeys.vehicle, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WatchmenCreateResponse> createWatchmen(String token,
      {required String vWatchmenName,
      required String vWatchmenNumber,
      required String vWatchmenAddress,
      required int vWatchmenType,
      required int iSocietyWingId,
      required int iOnDuty}) async {
    //
    final _data = {
      'vWatchmenName': vWatchmenName,
      'vWatchmenNumber': vWatchmenNumber,
      'vWatchmenAddress': vWatchmenAddress,
      'vWatchmenType': vWatchmenType,
      'iSocietyWingId': iSocietyWingId,
      'iOnDuty': iOnDuty
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WatchmenCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.watchmen, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WatchmenCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WatchmenCreateResponse> updateWatchmen(String token,
      {required int iWatchmenId,
      required String vWatchmenName,
      required String vWatchmenNumber,
      required String vWatchmenAddress,
      required int vWatchmenType,
      required int iSocietyWingId,
      required int iOnDuty}) async {
    //
    final _data = {
      'iWatchmenId': iWatchmenId,
      'vWatchmenName': vWatchmenName,
      'vWatchmenNumber': vWatchmenNumber,
      'vWatchmenAddress': vWatchmenAddress,
      'vWatchmenType': vWatchmenType,
      'iSocietyWingId': iSocietyWingId,
      'iOnDuty': iOnDuty
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WatchmenCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.watchmen, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WatchmenCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleCreateResponse> createVehicle(String token,
      {required int iUserWingId,
      required int iVehicleType,
      required String vVehicleNumber}) async {
    //
    final _data = {
      'iUserWingId': iUserWingId,
      'iVehicleType': iVehicleType,
      'vVehicleNumber': vVehicleNumber
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.vehicle, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleCreateResponse> updateVehicle(String token,
      {required int iVehicleId,
      required int iVehicleType,
      required String vVehicleNumber}) async {
    //
    final _data = {
      'iVehicleId': iVehicleId,
      'iVehicleType': iVehicleType,
      'vVehicleNumber': vVehicleNumber
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.vehicle, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ChangePasswordResponse> changePassword(String token,
      {required String vPassword, required String nVPassword}) async {
    //
    final _data = {
      'vPassword': vPassword,
      'nVPassword': nVPassword,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ChangePasswordResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.changePassword, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ChangePasswordResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionCreateResponse> createTransaction(String token,
      {required int iUserId,
      required int iSocietyWingId,
      required int iTransactionType,
      required String vPaymentType,
      required int iAmount,
      required String dPaymentDate,
      required String vPaymentDetails,
      required String vTransactionDetails,
      required int iAddId}) async {
    //
    final _data = {
      'iUserId': iUserId,
      'iSocietyWingId': iSocietyWingId,
      'iTransactionType': iTransactionType,
      'vPaymentType': vPaymentType,
      'iAmount': iAmount,
      'dPaymentDate': dPaymentDate,
      'vPaymentDetails': vPaymentDetails,
      'vTransactionDetails': vTransactionDetails,
      'iAddId': iAddId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TransactionCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.transaction, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TransactionCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionsAddResponse> addTransactions(
    String token, {
    @Field("listTransaction") required List<dynamic> listTransaction,
  }) async {
    //
    final _data = {
      'maintenanceList': listTransaction,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TransactionsAddResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.multipleTransaction, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TransactionsAddResponse.fromJson(_result.data!);
    return value;
  }

  /// Inquiry
  @override
  Future<InquiryResponse> inquiry(
      {required String vUserName,
      required String vSocietyName,
      required String vSocietyAddress,
      required String vCity,
      required String vState,
      required String vPincode,
      required String vMobile}) async {
    final _data = {
      'vUserName': vUserName,
      'vSocietyName': vSocietyName,
      'vSocietyAddress': vSocietyAddress,
      'vCity': vCity,
      'vState': vState,
      'vPincode': vPincode,
      'vMobile': vMobile,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<InquiryResponse>(Options(method: 'POST')
            .compose(_dio.options, LocaleKeys.addInquiry, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = InquiryResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NoticeResponse> getNotice(String token,
      {required int iSocietyWingId}) async {
    final _data = {'iSocietyWingId': iSocietyWingId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NoticeResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.addNotice, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NoticeResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NoticeCreateResponse> updateNotice(String token,
      {required int iNoticeId,
        required String vNoticeDetail}) async {
    //
    final _data = {
      'iNoticeId': iNoticeId,
      'vNoticeDetail': vNoticeDetail
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NoticeCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addNotice, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NoticeCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NoticeCreateResponse> createNotice(String token,
      {required int iUserId,
      required int iSocietyWingId,
      required String vNoticeDetail}) async {
    //
    final _data = {
      'iUserId': iUserId,
      'iSocietyWingId': iSocietyWingId,
      'vNoticeDetail': vNoticeDetail
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NoticeCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addNotice, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NoticeCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NoticeCreateResponse> deleteNotice(String token,
      {required int iNoticeId}) async {
    //
    final _data = {
      'iNoticeId': iNoticeId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NoticeCreateResponse>(
            Options(method: 'DELETE', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addNotice, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NoticeCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AssetsResponse> getAssets(String token,
      {required int iSocietyWingId}) async {
    final _data = {'iSocietyWingId': iSocietyWingId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsResponse>(Options(
                method: 'GET', headers: _header(true))
            .compose(_dio.options, LocaleKeys.addAssets, queryParameters: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AssetsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AssetsCreateResponse> createAssets(String token,
      {required int iUserId,
      required int iSocietyWingId,
      required String vAssetName,
      required String iQty}) async {
    //
    final _data = {
      'iUserId': iUserId,
      'iSocietyWingId': iSocietyWingId,
      'vAssetName': vAssetName,
      'iQty': iQty,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addAssets, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AssetsCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AssetsCreateResponse> updateAssets(String token,
      {required int iAssetsId,
        required String vAssetName,
        required String iQty}) async {
    //
    final _data = {
      'iAssetsId': iAssetsId,
      'vAssetName': vAssetName,
      'iQty': iQty
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addAssets, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AssetsCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AssetsCreateResponse> deleteAssets(String token,
      {required int iAssetsId}) async {
    //
    final _data = {
      'iAssetsId': iAssetsId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(
            Options(method: 'DELETE', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addAssets, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AssetsCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SupportCreateResponse> createSupport(String token,
      {required int iUserId, required String vSupportDetails}) async {
    //
    final _data = {
      'iUserId': iUserId,
      'vSupportDetails': vSupportDetails,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addSupport, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SupportCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SupportResponse> getSupport(String token,
      {required int iUserId}) async {
    final _data = {'iUserId': iUserId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addSupport,
                    queryParameters: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SupportResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookingResponse> getBooking(String token,
      {required int iSBookablePropertyId}) async {
    final _data = {'iSBookablePropertyId': iSBookablePropertyId};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addBooking,
                    queryParameters: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookingCreateResponse> createBooking(String token,
      {required String iSBookablePropertyId,
      required String dtBooking,
      required int iUserId,
      required String vUserName,
      required String vMobile,
      required String vAltMobile,
      required String vAddress,
      required String iBookingTypeId,
      required String iAdvance,
      required String iRent}) async {
    //
    final _data = {
      'iSBookablePropertyId': iSBookablePropertyId,
      'dtBooking': dtBooking,
      'iUserId': iUserId,
      'vUserName': vUserName,
      'vMobile': vMobile,
      'vAltMobile': vAltMobile,
      'vAddress': vAddress,
      'iBookingTypeId': iBookingTypeId,
      'iAdvance': iAdvance,
      'iRent': iRent,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(
            Options(method: 'POST', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addBooking, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookingCreateResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookablePropertyCreateResponse> createBookableProperty(String token,
      {required int iSocietyId,
      required int iUserId,
      required String vSocietyWingIds,
      required String vPropertyName}) async {
    //
    final _data = {
      'iSocietyId': iSocietyId,
      'iUserId': iUserId,
      'vSocietyWingIds': vSocietyWingIds,
      'vPropertyName': vPropertyName,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsCreateResponse>(Options(
                method: 'POST', headers: _header(true))
            .compose(_dio.options, LocaleKeys.addBookableProperty, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookablePropertyCreateResponse.fromJson(_result.data!);
    return value;
  }


  @override
  Future<BookablePropertyCreateResponse> updateBookableProperty(String token,
      {required int iSBookablePropertyId,
        required String vPropertyName}) async {
    //
    final _data = {
      'iSBookablePropertyId': iSBookablePropertyId,
      'vPropertyName': vPropertyName
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BookablePropertyCreateResponse>(
            Options(method: 'PUT', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addBookableProperty, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookablePropertyCreateResponse.fromJson(_result.data!);
    return value;
  }


  @override
  Future<BookablePropertyResponse> getBookableProperty(String token,
      {required String vSocietyWingIds}) async {
    final _data = {'vSocietyWingIds': vSocietyWingIds};
    //
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AssetsResponse>(
            Options(method: 'GET', headers: _header(true))
                .compose(_dio.options, LocaleKeys.addBookableProperty,
                    queryParameters: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookablePropertyResponse.fromJson(_result.data!);
    return value;
  }
}
