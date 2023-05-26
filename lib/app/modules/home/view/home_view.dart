import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/home/model/constant_model.dart';
import 'package:maintaince/app/modules/home/viewmodel/home_viewmodel.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/google_font.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> selected = [];
  List<String> imageList = [
    LocaleKeys.ic_member,
    LocaleKeys.ic_transaction,
    LocaleKeys.ic_watchmen,
    LocaleKeys.ic_vehicle
  ];

  List<dynamic> adsList = [];
  List<String> balanceList = [];
  static GlobalKey<ScaffoldState> key = GlobalKey();
  late HomeViewModel _service;
  ConstantData? constantDatas;
  var totalBalance = 0;
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late Timer _timer;
  var isExpire = false;
  var isInternet = false;

    UserData? userData;

    late SharedPreferences prefs;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      _updateInfo = info;
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) => {});
      }
    }).catchError((e) {
      // showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (key.currentContext != null) {
      ScaffoldMessenger.of(key.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    _service = HomeViewModel(context);
    getUserData();
    getUserDrawerData();
    getConstant();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (adsList.isNotEmpty) {
        if (_currentPage < adsList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        print(_currentPage);
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: greyBackground,
          key: key,
          drawer: Drawer  (
            backgroundColor: whiteColor,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 80.w,
                              height: 80.w,
                              child: Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 48,
                                    backgroundImage:
                                        AssetImage(LocaleKeys.ic_dummy_user),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var result = await Get.toNamed(
                                          Routes.EDIT_PROFILE);
                                      if (result != null && result is bool) {
                                        if (result) {
                                          getUserDrawerData();
                                        }
                                      }
                                      key.currentState?.closeDrawer();
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blackColor,
                                        ),
                                        padding: EdgeInsets.all(6.w),
                                        child: Image.asset(
                                          LocaleKeys.ic_edit,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              userData?.vUserName ?? "",
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16.w,
                        ),
                        Image.asset(
                          LocaleKeys.ic_drawer_address,
                          color: iconColor,
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Expanded(
                          child: Text(
                            userData == null
                                ? ""
                                : "${userData?.wings[0].vWingName ?? ""}-${userData?.wings[0].vHouseNo ?? ""}, ${userData?.wings[0].vSocietyName} - ${userData?.wings[0].iPincode}, ${userData?.wings[0].vCity}",
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Share.share(
                                "Address : ${userData?.wings[0].vWingName ?? ""}-${userData?.wings[0].vHouseNo ?? ""}, ${userData?.wings[0].vSocietyName} - ${userData?.wings[0].iPincode}, ${userData?.wings[0].vCity}\nhttp://maps.google.com/maps?q=loc:${userData?.wings[0].vLat},${userData?.wings[0].vLong}");
                          },
                          child: Image.asset(
                            LocaleKeys.ic_share,
                            color: iconColor,
                            fit: BoxFit.cover,
                            height: 18.h,
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.MY_TRANSACTION_VIEW);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_drawer_transaction,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.myTransactions.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.SUPPORT);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_drawer_support,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.support.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.INTERSTITIAL_VIEW);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_drawer_terms,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.termsConditions.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.LANGUAGE_VIEW);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_language,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.changeLanguage.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PASSWORD_CHANGE);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_drawer_password,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.changePasswordV.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                      key.currentState?.closeDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            LocaleKeys.ic_drawer_logout,
                            color: iconColor,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.logoutName.tr,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0.5,
            iconTheme: IconThemeData(color: blackColor, size: 30,),
            title: Text(
              LocaleKeys.dashboardName.tr,
              style: TextStyle(
                  color: blackColor,
                  fontFamily: AssetsFont.fontBold,
                  fontSize: 16),
            ),
            leading: GestureDetector(
              onTap: () {
                key.currentState?.openDrawer();
              },
              child: Image.asset(
                LocaleKeys.ic_menu,
                color: blackColor,
                scale: 1.9,
                // height: 10.h,
                // width: 10.h,
              ),
            ),
            // actions: [
            //   Container(
            //     margin: EdgeInsets.symmetric(vertical: 10.sp),
            //     width: 26,
            //     height: 26,
            //     child: GestureDetector(
            //       onTap: () {
            //         // Get.toNamed(Routes.PROFILE);
            //         Get.toNamed(Routes.NOTIFICATION);
            //       },
            //       child: Image.asset(
            //         LocaleKeys.ic_notification_new,
            //       ),
            //     ),
            //   ),
            //   SizedBox(
            //     width: 20.w,
            //   )
            // ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: isExpire,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: transRed,
                          elevation: 0,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            child: Text(
                              LocaleKeys.planExpired.tr,
                              style: TextStyle(
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isInternet,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: transRed,
                          elevation: 0,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    LocaleKeys.internetMsg.tr,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    getConstant();
                                  },
                                  child: Image.asset(
                                    LocaleKeys.ic_retry,
                                    width: 24.w,
                                    height: 24.h,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: true, //!(constantDatas?.isPurchase ?? false),
                  child: SizedBox(
                    height: 10.h,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 110.h,
                          child: PageView.builder(
                            controller: _controller,
                            onPageChanged: (index) {
                              _currentPage = index;
                            },
                            itemBuilder: (context, index) {
                              var data = adsList[index];
                              if (data == null) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.sp),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.asset(
                                                LocaleKeys.ic_balance_card_back,
                                                fit: BoxFit.fill,
                                                height: 170.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Text(
                                              "${LocaleKeys.wing.tr} ${userData!.wings[index].vWingName} - ${LocaleKeys.totalBalance.tr}",
                                              style:
                                                  TextStyle(color: blackColor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Text(
                                              "₹${balanceList[index]}",
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 36.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    _launchURL(data.vAdLink!);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.sp),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  (data as AdsData)
                                                          .vAdImageUrl ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: adsList.length,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Visibility(
                          visible: !isInternet && adsList.isEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SmoothPageIndicator(
                                controller: _controller,
                                count: adsList.length,
                                effect: WormEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: themeColor),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !isInternet && adsList.isEmpty,
                          child: SizedBox(height: 10.h),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: [
                                  ComanContiner(() {
                                    Get.toNamed(Routes.USER_VIEW);
                                  }, LocaleKeys.ic_members_new,
                                      LocaleKeys.members.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.MAINTAINANCE_VIEW);
                                  }, LocaleKeys.ic_maintainance,
                                      LocaleKeys.maintenance.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.TRANSACTION_VIEW);
                                  }, LocaleKeys.ic_transactionn_new,
                                      LocaleKeys.transactionV.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.BOOKABLE_PROPERTY_VIEW);
                                  }, LocaleKeys.ic_communityhall_new,
                                      LocaleKeys.amenities.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.WATCHMEN_VIEW);
                                  }, LocaleKeys.ic_watchmen_new,
                                      LocaleKeys.watchman.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.VEHICLE_VIEW);
                                  }, LocaleKeys.ic_vehicle_new,
                                      LocaleKeys.vehicleV.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.NOTICE);
                                  }, LocaleKeys.ic_notice_new,
                                      LocaleKeys.notice.tr),
                                  ComanContiner(() {
                                    Get.toNamed(Routes.ASSETS);
                                  }, LocaleKeys.ic_asset_new,
                                      LocaleKeys.asset.tr),
                                  ComanContiner(() {
                                    // Get.toNamed(Routes.REMINDER);
                                    flutterToastBottom("Coming Soon");
                                  }, LocaleKeys.ic_reminder_new,
                                      LocaleKeys.reminder.tr),
                                  // ComanContiner(() {},
                                  //     LocaleKeys.ic_report_new,
                                  //     LocaleKeys.report.tr),
                                ],
                              ),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getConstant() async {
    if (ConnectivityUtils.instance.hasInternet) {
      setState(() {
        isInternet = false;
      });
      var constantData = await _service.constant();
      if (constantData?.isSuccess ?? false) {
        final prefs = await SharedPreferences.getInstance();
        adsList.clear();
        setState(() {
          constantDatas = constantData?.data;
          isExpire = !(constantDatas?.isPurchase ?? false);
          for (var element in userData!.wings) {
            adsList.add(null);
            balanceList.add("0");
          }
          if (constantData?.data?.tblAds != null) {
            adsList.addAll(constantData!.data!.tblAds!);
          }
        });
        prefs.setString("constantData", jsonEncode(constantData?.data));
      } else {
        if ((constantData?.vMessage ?? "") ==
            "Authentication bearer token invalid") {
          prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Get.offAllNamed(Routes.LOGIN);
        }
      }

      for (var element in userData!.wings) {
        var balanceData = await _service.getBalance(element.iSocietyWingId!);
        if (balanceData?.isSuccess ?? false) {
          setState(() {
            balanceList[userData!.wings.indexOf(element)] =
                "${balanceData?.data ?? 0}";
          });
        }
      }
    } else {
      setState(() {
        isInternet = true;
      });
    }
  }

  _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  void getUserData() async {
    prefs = await SharedPreferences.getInstance();
    //userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    userData = UserData.fromJson(jsonDecode(PreferenceManager.getString("userData")));
  }

  Widget ComanContiner(ontaP, image, text) {
    return GestureDetector(
      onTap: ontaP,
      child: Container(
        // height: 90,
        // width: 40,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image, height: 55, width: 55),
            Text(text,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AssetsFont.fontMedium,
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.logoutName.tr),
      onPressed: () async {
        Get.back();
        //await prefs.clear();

        Get.offAllNamed(Routes.LOGIN);
      },
    );
    Widget cancelBtn = TextButton(
      child: Text(LocaleKeys.logoutCancelMessage.tr),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text(LocaleKeys.logoutMessage.tr),
      actions: [
        cancelBtn,
        logoutBtn,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getUserDrawerData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userData =
          UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    });
  }
}
