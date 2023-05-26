import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/app/modules/watchmen/viewmodel/watchmen_viewmodel.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchmenView extends StatefulWidget {
  const WatchmenView({Key? key}) : super(key: key);

  @override
  _WatchmenViewState createState() => _WatchmenViewState();
}

class _WatchmenViewState extends State<WatchmenView> {
  late WatchmenViewModel _service;

  List<WatchmenData> watchmenList = [];

  UserData? userData;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _service = WatchmenViewModel(context);
    getUserData();
    getWatchmen();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: greyBackground,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: blackColor, //change your color here
        ),
        title: Text(
          LocaleKeys.watchman.tr,
          style: TextStyle(color: blackColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Visibility(
              visible: watchmenList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: watchmenList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (isEditable) {
                          showCustomDialog(context, watchmenList[index]);
                        }
                      },
                      child: Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.sp),
                                width: 50,
                                height: 50,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        LocaleKeys.ic_dummy_user,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: Image.asset(
                                        watchmenList[index].vWatchmenType == 0
                                            ? LocaleKeys.ic_day
                                            : watchmenList[index]
                                                        .vWatchmenType ==
                                                    1
                                                ? LocaleKeys.ic_night
                                                : LocaleKeys.ic_day_night,
                                        height: 20.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      watchmenList[index].vWatchmenType == 0
                                          ? "${watchmenList[index].vWatchmenName ?? ""} - ${LocaleKeys.day.tr}"
                                          : watchmenList[index].vWatchmenType ==
                                                  1
                                              ? "${watchmenList[index].vWatchmenName ?? ""} - ${LocaleKeys.night.tr}"
                                              : "${watchmenList[index].vWatchmenName ?? ""} - ${LocaleKeys.full.tr}",
                                      style: TextStyle(
                                        color: blackColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "${LocaleKeys.mobileNo.tr} ${watchmenList[index].vWatchmenNumber}",
                                      style: TextStyle(
                                        color: grayColor,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var url =
                                      "tel:${watchmenList[index].vWatchmenNumber ?? ""}";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Image.asset(
                                  LocaleKeys.ic_phone_call,
                                  color: iconColor,
                                  fit: BoxFit.cover,
                                  height: 16.h,
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              if (userData!.wings[0].iUserTypeId != 5)
                                Switch(
                                  value: watchmenList[index].iOnDuty == 0,
                                  onChanged: isEditable
                                      ? (value) {
                                          setState(
                                            () {
                                              if (watchmenList[index].iOnDuty ==
                                                  0) {
                                                watchmenList[index].iOnDuty = 1;
                                              } else {
                                                watchmenList[index].iOnDuty = 0;
                                              }
                                            },
                                          );
                                        }
                                      : null,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: watchmenList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.noWatchmanFound.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isEditable,
        child: Align(
          alignment: const Alignment(0.85, 0.94),
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(Routes.WATCHMEN_CREATE);
              if (result != null) {
                setState(() {
                  watchmenList.add(result);
                });
              }
            },
            backgroundColor: pinkColor,
            child: Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context, WatchmenData watchmenData) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.selectOption.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () async {
                    Get.back();
                    Map<String, dynamic> map = {
                      'isEdit': true,
                      'watchmenData': watchmenData
                    };
                    var result = await Get.toNamed(Routes.WATCHMEN_CREATE,
                        arguments: map);
                    if (result != null) {
                      var index = watchmenList.indexWhere((element) =>
                          element.iWatchmenId ==
                          (result as WatchmenData).iWatchmenId);
                      if (index != -1) {
                        setState(() {
                          watchmenList[index] = result;
                        });
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      LocaleKeys.edit.tr,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                GestureDetector(
                  onTap: () async {
                    Get.back();
                    showDeleteDialog(context, watchmenData);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      LocaleKeys.delete.tr,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  showDeleteDialog(BuildContext context, WatchmenData watchmenData) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        var deleteData =
            await _service.deleteWatchmen(watchmenData.iWatchmenId ?? 0);
        if (deleteData?.isSuccess ?? false) {
          var index = watchmenList.indexWhere(
              (element) => element.iWatchmenId == watchmenData.iWatchmenId);
          if (index != -1) {
            setState(() {
              watchmenList.removeAt(index);
            });
          }
        }
        flutterToastBottomGreen(deleteData?.vMessage ?? "");
      },
    );
    Widget cancelBtn = TextButton(
      child: Text(LocaleKeys.logoutCancelMessage.tr),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text(LocaleKeys.deleteMessageWatchmen.tr),
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

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    var wingList = userData!.wings;
    if (wingList.isNotEmpty) {
      var temp = wingList.where((element) =>
          element.iUserTypeId == 1 ||
          element.iUserTypeId == 2 ||
          element.iUserTypeId == 3);
      if (temp.isNotEmpty) {
        setState(() {
          isEditable = true;
        });
      }
    }
  }

  void getWatchmen() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var constantData = await _service.getWatchmen();
      if (constantData?.isSuccess ?? false) {
        setState(() {
          watchmenList = constantData?.data ?? [];
        });
      } else {
        flutterToastBottom(LocaleKeys.internetMsg);
      }
    }
  }
}
