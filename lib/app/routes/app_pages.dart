import 'package:get/get.dart';
import 'package:maintaince/app/ads/interstitial_ads.dart';
import 'package:maintaince/app/modules/Hallbooking/view/booking_create.dart';
import 'package:maintaince/app/modules/Hallbooking/view/booking_view.dart';
import 'package:maintaince/app/modules/addbookableproperty/view/bookable_property_create.dart';
import 'package:maintaince/app/modules/home/view/home_view.dart';
import 'package:maintaince/app/modules/inquiry/view/inquiry_view.dart';
import 'package:maintaince/app/modules/language/view/language_view.dart';
import 'package:maintaince/app/modules/login/view/login_view.dart';
import 'package:maintaince/app/modules/maintenance/view/maintenance_view.dart';
import 'package:maintaince/app/modules/mysupport/view/support_create.dart';
import 'package:maintaince/app/modules/mysupport/view/support_view.dart';
import 'package:maintaince/app/modules/mytransaction/view/my_transaction_view.dart';
import 'package:maintaince/app/modules/notice/view/notice_view.dart';
import 'package:maintaince/app/modules/notification/view/notification_view.dart';
import 'package:maintaince/app/modules/password/view/password_change.dart';
import 'package:maintaince/app/modules/privacy/view/privacy_view.dart';
import 'package:maintaince/app/modules/splash/view/splash_view.dart';
import 'package:maintaince/app/modules/transaction/view/transaction_create.dart';
import 'package:maintaince/app/modules/transaction/view/transaction_view.dart';
import 'package:maintaince/app/modules/user/view/user_create.dart';
import 'package:maintaince/app/modules/user/view/user_view.dart';
import 'package:maintaince/app/modules/vehicle/view/vehicle_create.dart';
import 'package:maintaince/app/modules/vehicle/view/vehicle_view.dart';
import 'package:maintaince/app/modules/watchmen/view/watchmen_create.dart';
import 'package:maintaince/app/modules/watchmen/view/watchmen_view.dart';

import '../modules/home/view/edit_profile_view.dart';
import '../modules/addbookableproperty/view/bookable_property_view.dart';
import '../modules/maintenance/view/maintenance_create.dart';
import '../modules/myassets/view/assets_create.dart';
import '../modules/myassets/view/assets_view.dart';
import '../modules/notice/view/notice_create.dart';
import '../modules/reminder/view/reminder_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: _Paths.REGISTER_VIEW,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: _Paths.NOTICE,
      page: () => const NoticeView(),
    ),
    GetPage(
      name: _Paths.NOTICE_CREATE,
      page: () => const NoticeCreateView(),
    ),
    GetPage(
      name: _Paths.REMINDER,
      page: () => const ReminderView(),
    ),
    GetPage(
      name: _Paths.ASSETS,
      page: () => const AssetsView(),
    ),
    GetPage(
      name: _Paths.ASSET_CREATE,
      page: () => const AssetsCreateView(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
    ),
    GetPage(
      name: _Paths.USER_CREATE,
      page: () => const UserCreateView(),
    ),
    GetPage(
      name: _Paths.USER_VIEW,
      page: () => const UserView(),
    ),
    GetPage(
      name: _Paths.WATCHMEN_VIEW,
      page: () => const WatchmenView(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_VIEW,
      page: () => const TransactionView(),
    ),
    GetPage(
      name: _Paths.MY_TRANSACTION_VIEW,
      page: () => const MyTransactionView(),
    ),
    GetPage(
      name: _Paths.VEHICLE_VIEW,
      page: () => const VehicleView(),
    ),
    GetPage(
      name: _Paths.VEHICLE_CREATE,
      page: () => const VehicleCreateView(),
    ),
    GetPage(
      name: _Paths.WATCHMEN_CREATE,
      page: () => const WatchmenCreateView(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_CREATE,
      page: () => const TransactionCreateView(),
    ),
    GetPage(
      name: _Paths.BOOKABLE_PROPERTY_VIEW,
      page: () => const BookablePropertyView(),
    ),
    GetPage(
      name: _Paths.BOOKABLE_PROPERTY,
      page: () => const BookablePropertyCreateView(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
    ),
    GetPage(
      name: _Paths.BOOKING_CREATE,
      page: () => const BookingCreateView(),
    ),
    GetPage(
      name: _Paths.PASSWORD_CHANGE,
      page: () => const PasswordChangeView(),
    ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => const MySupportView(),
    ),
    GetPage(
      name: _Paths.MAINTAINANCE_VIEW,
      page: () => const MaintenanceView(),
    ),
    GetPage(
      name: _Paths.MAINTAINANCE_CREATE,
      page: () => const MaintenanceCreateView(),
    ),
    GetPage(
      name: _Paths.SUPPORT_CREATE,
      page: () => const SupportCreateView(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyView(),
    ),
    GetPage(
      name: _Paths.INTERSTITIAL_VIEW,
      page: () => const InterstitialAdsView(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_VIEW,
      page: () => const LanguageView(),
    ),
  ];
}
