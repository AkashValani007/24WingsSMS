part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const VIEW_PROFILE = _Paths.VIEW_PROFILE;
  static const PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const NOTICE = _Paths.NOTICE;
  static const NOTICE_CREATE = _Paths.NOTICE_CREATE;
  static const USER_CREATE = _Paths.USER_CREATE;
  static const USER_VIEW = _Paths.USER_VIEW;
  static const WATCHMEN_VIEW = _Paths.WATCHMEN_VIEW;
  static const TRANSACTION_VIEW = _Paths.TRANSACTION_VIEW;
  static const MY_TRANSACTION_VIEW = _Paths.MY_TRANSACTION_VIEW;
  static const VEHICLE_VIEW = _Paths.VEHICLE_VIEW;
  static const VEHICLE_CREATE = _Paths.VEHICLE_CREATE;
  static const WATCHMEN_CREATE = _Paths.WATCHMEN_CREATE;
  static const TRANSACTION_CREATE = _Paths.TRANSACTION_CREATE;
  static const PASSWORD_CHANGE = _Paths.PASSWORD_CHANGE;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
  static const REGISTER_VIEW = _Paths.REGISTER_VIEW;
  static const ASSETS = _Paths.ASSETS;
  static const ASSET_CREATE = _Paths.ASSET_CREATE;
  static const SUPPORT = _Paths.SUPPORT;
  static const SUPPORT_CREATE = _Paths.SUPPORT_CREATE;
  static const REMINDER = _Paths.REMINDER;
  static const BOOKING = _Paths.BOOKING;
  static const BOOKABLE_PROPERTY = _Paths.BOOKABLE_PROPERTY;
  static const BOOKABLE_PROPERTY_VIEW = _Paths.BOOKABLE_PROPERTY_VIEW;
  static const BOOKING_CREATE = _Paths.BOOKING_CREATE;
  static const MAINTAINANCE_VIEW = _Paths.MAINTAINANCE_VIEW;
  static const MAINTAINANCE_CREATE = _Paths.MAINTAINANCE_CREATE;
  static const INTERSTITIAL_VIEW = _Paths.INTERSTITIAL_VIEW;
  static const LANGUAGE_VIEW = _Paths.LANGUAGE_VIEW;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const VIEW_PROFILE = '/viewprofile';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/editprofile';
  static const NOTIFICATION = '/notification';
  static const NOTICE = '/notice';
  static const NOTICE_CREATE = '/createNotice';
  static const ASSETS = '/Asset';
  static const ASSET_CREATE = '/createAsset';
  static const USER_CREATE = '/createUser';
  static const USER_VIEW = '/viewUser';
  static const WATCHMEN_VIEW = '/viewWatchmen';
  static const TRANSACTION_VIEW = '/viewTransaction';
  static const MY_TRANSACTION_VIEW = '/viewMyTransaction';
  static const VEHICLE_VIEW = '/viewVehicle';
  static const VEHICLE_CREATE = '/createVehicle';
  static const TRANSACTION_CREATE = '/createTransaction';
  static const WATCHMEN_CREATE = '/createWatchmen';
  static const PASSWORD_CHANGE = '/changePassword';
  static const PRIVACY_POLICY = '/privacypolicy';
  static const REGISTER_VIEW = '/registerView';
  static const SUPPORT = '/mysupport';
  static const SUPPORT_CREATE = '/createSupport';
  static const REMINDER = '/reminder';
  static const BOOKABLE_PROPERTY = '/BookableProperty';
  static const BOOKABLE_PROPERTY_VIEW = '/BookablePropertyView';
  static const BOOKING = '/Hallbooking';
  static const BOOKING_CREATE = '/createBooking';
  static const MAINTAINANCE_VIEW = '/maintainance';
  static const MAINTAINANCE_CREATE = '/createMaintainance';
  static const INTERSTITIAL_VIEW = '/interstitial_view';
  static const LANGUAGE_VIEW = '/language_view';

}
