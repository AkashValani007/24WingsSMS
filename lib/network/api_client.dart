import 'package:dio/dio.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_create_model.dart';
import 'package:maintaince/app/modules/addbookableproperty/model/bookable_property_create_model.dart';
import 'package:maintaince/app/modules/addbookableproperty/model/bookable_property_model.dart';
import 'package:maintaince/app/modules/home/model/balance_model.dart';
import 'package:maintaince/app/modules/home/model/constant_model.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/password/model/change_password_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_create_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';
import 'package:maintaince/app/modules/transaction/model/transactions_add_model.dart';
import 'package:maintaince/app/modules/user/model/user_create_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/app/modules/vehicle/model/vehicle_create_model.dart';
import 'package:maintaince/app/modules/vehicle/model/vehicle_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_crate_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:retrofit/retrofit.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_model.dart';
import '../app/modules/inquiry/model/constant_city_model.dart';
import '../app/modules/inquiry/model/inquiry_model.dart';

import '../app/modules/myassets/model/assets_create_model.dart';
import '../app/modules/myassets/model/assets_model.dart';
import '../app/modules/mysupport/model/Support_create_model.dart';
import '../app/modules/mysupport/model/Support_model.dart';
import '../app/modules/notice/model/notice_create_model.dart';
import '../app/modules/notice/model/notice_model.dart';
import '../app/widget/preference_manager.dart';
import 'interceptor/api_interceptor.dart';
import 'interceptor/cache_interceptor.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  static late ApiClient _instance;
  static late Dio dio;
  static const bool doWriteLog = true;
  static const bool doEncryption = false;

  static ApiClient get instance => _instance;

  factory ApiClient._private(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(LocaleKeys.login)
  Future<LoginResponse> login(
      {@Field("vMobile") required String vMobile,
      @Field("vPassword") required String vPassword});

  @POST(LocaleKeys.createUser)
  Future<UserCreateResponse> createUser(
    String token, {
    @Field("iSocietyWingId") required int iSocietyWingId,
    @Field("iUserTypeId") required int userTypes,
    @Field("isOwner") required int isOwner,
    @Field("isCommitteeMember") required int isCommitteeMember,
    @Field("iHouseId") required int iHouseId,
    @Field("vUserName") required String name,
    @Field("vMobile") required String number,
    @Field("vPassword") required String vPassword,
    @Field("vEmail") required String email,
    @Field("vBusinessName") required String bName,
    @Field("vBusinessAddress") required String bAddress,
  });

  @PUT(LocaleKeys.createUser)
  Future<UserCreateResponse> updateUser(
    String token, {
    @Field("iUserId") required int iUserId,
    @Field("name") required String name,
    @Field("number") required String number,
    @Field("iHouseId") required int iHouseId,
    @Field("email") required String email,
    @Field("bName") required String bName,
    @Field("iSocietyWingId") required int iSocietyWingId,
    @Field("bAddress") required String bAddress,
    @Field("userTypes") required int userTypes,
  });

  @PUT(LocaleKeys.createUser)
  Future<UserCreateResponse> editUser(
    String token, {
    @Field("iUserId") required int iUserId,
    @Field("vUserName") required String vUserName,
    @Field("vEmail") required String vEmail,
    @Field("iGender") required int iGender,
    @Field("vBusinessName") required String vBusinessName,
    @Field("vBusinessAddress") required String vBusinessAddress,
    @Field("dtDOB") required String dtDOB,
  });

  @DELETE(LocaleKeys.createUser)
  Future<UserCreateResponse> deleteUser(
    String token, {
    @Field("iUserId") required int iUserId,
  });

  @DELETE(LocaleKeys.watchmen)
  Future<WatchmenCreateResponse> deleteWatchmen(
    String token, {
    @Field("iWatchmenId") required int iWatchmenId,
  });

  @DELETE(LocaleKeys.vehicle)
  Future<VehicleCreateResponse> deleteVehicle(
    String token, {
    @Field("iVehicleId") required int iVehicleId,
  });

  @POST(LocaleKeys.transaction)
  Future<TransactionCreateResponse> createTransaction(
    String token, {
    @Field("iUserId") required int iUserId,
    @Field("iSocietyWingId") required int iSocietyWingId,
    @Field("iTransactionType") required int iTransactionType,
    @Field("vPaymentType") required String vPaymentType,
    @Field("iAmount") required int iAmount,
    @Field("dPaymentDate") required String dPaymentDate,
    @Field("vPaymentDetails") required String vPaymentDetails,
    @Field("vTransactionDetails") required String vTransactionDetails,
    @Field("iAddId") required int iAddId,
  });

  @POST(LocaleKeys.multipleTransaction)
  Future<TransactionsAddResponse> addTransactions(
    String token, {
    @Field("listTransaction") required List<dynamic> listTransaction,
  });

  @POST(LocaleKeys.changePassword)
  Future<ChangePasswordResponse> changePassword(String token,
      {@Field("vPassword") required String vPassword,
      @Field("nVPassword") required String nVPassword});

  @POST(LocaleKeys.watchmen)
  Future<WatchmenCreateResponse> createWatchmen(String token,
      {@Field("vWatchmenName") required String vWatchmenName,
      @Field("vWatchmenNumber") required String vWatchmenNumber,
      @Field("vWatchmenAddress") required String vWatchmenAddress,
      @Field("vWatchmenType") required int vWatchmenType,
      @Field("iSocietyWingId") required int iSocietyWingId,
      @Field("iOnDuty") required int iOnDuty});

  @PUT(LocaleKeys.watchmen)
  Future<WatchmenCreateResponse> updateWatchmen(String token,
      {@Field("iWatchmenId") required int iWatchmenId,
      @Field("vWatchmenName") required String vWatchmenName,
      @Field("vWatchmenNumber") required String vWatchmenNumber,
      @Field("vWatchmenAddress") required String vWatchmenAddress,
      @Field("vWatchmenType") required int vWatchmenType,
      @Field("iSocietyWingId") required int iSocietyWingId,
      @Field("iOnDuty") required int iOnDuty});

  @POST(LocaleKeys.vehicle)
  Future<VehicleCreateResponse> createVehicle(String token,
      {@Field("iUserWingId") required int iUserWingId,
      @Field("iVehicleType") required int iVehicleType,
      @Field("vVehicleNumber") required String vVehicleNumber});

  @POST(LocaleKeys.addInquiry)
  Future<InquiryResponse> inquiry({
    @Field("vUserName") required String vUserName,
    @Field("vSocietyName") required String vSocietyName,
    @Field("vSocietyAddress") required String vSocietyAddress,
    @Field("vCity") required String vCity,
    @Field("vState") required String vState,
    @Field("vPincode") required String vPincode,
    @Field("vMobile") required String vMobile,
  });

  @PUT(LocaleKeys.vehicle)
  Future<VehicleCreateResponse> updateVehicle(String token,
      {@Field("iVehicleId") required int iVehicleId,
      @Field("iVehicleType") required int iVehicleType,
      @Field("vVehicleNumber") required String vVehicleNumber});

  @GET(LocaleKeys.constant)
  Future<ConstantResponse> constant(String token);

  @GET(LocaleKeys.city)
  Future<ConstantCityResponse> constantCity();

  @GET(LocaleKeys.balance)
  Future<BalanceResponse> getBalance(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId});

  @GET(LocaleKeys.watchmen)
  Future<WatchmenResponse> getWatchmen(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId});

  @GET(LocaleKeys.vehicle)
  Future<VehicleResponse> getVehicle(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId});

  @GET(LocaleKeys.getUser)
  Future<UserResponse> getUser(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId,
      @Field("timeStamp") required String timeStamp});

  // @GET(LocaleKeys.getHouseList)
  // Future<HouseResponse> getHouseList(String token,
  //     {@Field("iSocietyWingId") required int iSocietyWingId});

  @GET(LocaleKeys.transaction)
  Future<TransactionResponse> getTransaction(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId,
      @Field("vStartDate") required String vStartDate,
      @Field("vEndDate") required String vEndDate,
      @Field("iType") required int iType});

  @GET(LocaleKeys.transaction)
  Future<TransactionResponse> getMyTransaction(String token,
      {@Field("iUserId") required int iUserId});

  @GET(LocaleKeys.addNotice)
  Future<NoticeResponse> getNotice(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId});

  @POST(LocaleKeys.addNotice)
  Future<NoticeCreateResponse> createNotice(String token,
      {@Field("iUserId") required int iUserId,
      @Field("iSocietyWingId") required int iSocietyWingId,
      @Field("vNoticeDetail") required String vNoticeDetail});

  @PUT(LocaleKeys.addNotice)
  Future<NoticeCreateResponse> updateNotice(String token,
      {@Field("iNoticeId") required int iNoticeId,
        @Field("vNoticeDetail") required String vNoticeDetail});

  @DELETE(LocaleKeys.addNotice)
  Future<NoticeCreateResponse> deleteNotice(
    String token, {
    @Field("iNoticeId") required int iNoticeId,
  });

  @GET(LocaleKeys.addAssets)
  Future<AssetsResponse> getAssets(String token,
      {@Field("iSocietyWingId") required int iSocietyWingId});

  @POST(LocaleKeys.addAssets)
  Future<AssetsCreateResponse> createAssets(String token,
      {@Field("iUserId") required int iUserId,
      @Field("iSocietyWingId") required int iSocietyWingId,
      @Field("vAssetName") required String vAssetName,
      @Field("iQty") required String iQty});

  @PUT(LocaleKeys.addAssets)
  Future<AssetsCreateResponse> updateAssets(String token,
      {@Field("iAssetsId") required int iAssetsId,
        @Field("vAssetName") required String vAssetName,
        @Field("iQty") required String iQty});

  @DELETE(LocaleKeys.addNotice)
  Future<AssetsCreateResponse> deleteAssets(
    String token, {
    @Field("iAssetsId") required int iAssetsId,
  });

  @GET(LocaleKeys.addSupport)
  Future<SupportResponse> getSupport(String token,
      {@Field("iUserId") required int iUserId});

  @POST(LocaleKeys.addSupport)
  Future<SupportCreateResponse> createSupport(String token,
      {@Field("iUserId") required int iUserId,
      @Field("vSupportDetails") required String vSupportDetails});

  @GET(LocaleKeys.addAssets)
  Future<BookingResponse> getBooking(String token,
      {@Field("iSBookablePropertyId") required int iSBookablePropertyId});

  @POST(LocaleKeys.addAssets)
  Future<BookingCreateResponse> createBooking(
    String token, {
    @Field("iSBookablePropertyId") required String iSBookablePropertyId,
    @Field("dtBooking") required String dtBooking,
    @Field("iUserId") required int iUserId,
    @Field("vUserName") required String vUserName,
    @Field("vMobile") required String vMobile,
    @Field("vAltMobile") required String vAltMobile,
    @Field("vAddress") required String vAddress,
    @Field("iBookingTypeId") required String iBookingTypeId,
    @Field("iAdvance") required String iAdvance,
    @Field("iRent") required String iRent,
  });

  @GET(LocaleKeys.addBookableProperty)
  Future<BookablePropertyResponse> getBookableProperty(String token,
      {@Field("vSocietyWingIds") required String vSocietyWingIds});

  @POST(LocaleKeys.addBookableProperty)
  Future<BookablePropertyCreateResponse> createBookableProperty(
    String token, {
    @Field("iSocietyId") required int iSocietyId,
    @Field("iUserId") required int iUserId,
    @Field("vSocietyWingIds") required String vSocietyWingIds,
    @Field("vPropertyName") required String vPropertyName,
  });


  @PUT(LocaleKeys.addBookableProperty)
  Future<BookablePropertyCreateResponse> updateBookableProperty(String token,
      {@Field("iSBookablePropertyId") required int iSBookablePropertyId,
        @Field("vPropertyName") required String vPropertyName,
      });

  static Future<void> init() async {
    var options = BaseOptions(
      baseUrl: LocaleKeys.baseApi,
      connectTimeout: 30000,
      receiveTimeout: 60000,
      sendTimeout: 60000,
      headers: {
        "Content-Type": "application/json",
        "Accept": 'application/json'
      },
    );
    dio = Dio(options);
    dio.interceptors.addAll([
      ApiInterceptor(doEncryption: doEncryption, doWriteLog: doWriteLog),
      CacheInterceptor(),
    ]);
    _instance = ApiClient._private(dio, baseUrl: LocaleKeys.baseApi);
  }
}
