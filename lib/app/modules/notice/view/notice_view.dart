import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/notice/viewmodel/notice_viewmodel.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/notice_model.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({Key? key}) : super(key: key);

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  List<Notice> noticeList = [];
  late NoticeViewModel _service;

  List<WingData> wingList = [];
  WingData? wing;
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _service = NoticeViewModel(context);
    getUserData();
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
          LocaleKeys.notice.tr,
          style: TextStyle(color: blackColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: wingList.length != 1,
              child: SizedBox(
                height: 10.h,
              ),
            ),
            Visibility(
              visible: wingList.length != 1,
              child: Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.selectWing.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          wingList.isEmpty
                              ? Container()
                              : DropdownButton<WingData>(
                            hint: Text(LocaleKeys.selectWing.tr),
                            value: wing,
                            items: wingList.map((WingData value) {
                              return DropdownMenuItem<WingData>(
                                value: value,
                                child: Text(
                                  '${value.vSocietyName} - ${ LocaleKeys.wing.tr} ${value.vWingName}',
                                  style:
                                  TextStyle(color: blackColor),
                                ),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                wing = value;
                                getNotices();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: noticeList.isEmpty,
              child: Expanded(
                flex: 7,
                child: Center(
                  child: Text(
                    LocaleKeys.noNoticeFound.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: noticeList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (wing?.iUserTypeId == 1 ||
                          wing?.iUserTypeId == 2 ||
                          wing?.iUserTypeId == 3) {
                        showCustomDialog(context, noticeList[index]);
                      }
                    },
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius:  const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ],
                        ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(vertical: 10.sp),
                          //   width: 50,
                          //   height: 50,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(25),
                          //     child: Image.asset(
                          //       LocaleKeys.ic_dummy_user,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Flexible(
                            child: Text(
                              noticeList[index].vNoticeDetail.toString(),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              maxLines: 3,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 10),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: wing?.iUserTypeId == 1 ||
            wing?.iUserTypeId == 2 ||
            wing?.iUserTypeId == 3,
        child: Align(
          alignment: const Alignment(0.85, 0.94),
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(Routes.NOTICE_CREATE);
              if (result != null) {
                setState(() {
                  noticeList.add(result);
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

  void showCustomDialog(BuildContext context, Notice noticeData) {
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
                      'noticeData': noticeData
                    };
                    var result =
                    await Get.toNamed(Routes.NOTICE_CREATE, arguments: map);
                    if (result != null) {
                      var index = noticeList.indexWhere((element) =>
                      element.iNoticeId == (result as Notice).iNoticeId);
                      if (index != -1) {
                        setState(() {
                          noticeList[index] = result;
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
                    showDeleteDialog(context, noticeData);
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

  showDeleteDialog(BuildContext context, Notice noticeData) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        var deleteData = await _service.deleteNotice(noticeData.iNoticeId ?? 0);
        if (deleteData?.isSuccess ?? false) {
          var index = noticeList.indexWhere(
              (element) => element.iNoticeId == noticeData.iNoticeId);
          if (index != -1) {
            setState(() {
              noticeList.removeAt(index);
            });
          }
        }
        flutterToastBottomGreen(
            deleteData?.vMessage ?? "");
      },
    );
    Widget cancelBtn = TextButton(
      child: Text(LocaleKeys.logoutCancelMessage.tr),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text(LocaleKeys.deleteMessageNotice.tr),
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

    wingList = userData!.wings;
    setState(() {
      wing = wingList[0];
    });
    getNotices();
  }

  void getNotices() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var noticeData = await _service.getNotice(wing!.iSocietyWingId!);
      if (noticeData?.isSuccess ?? false) {
        setState(() {
          noticeList = noticeData?.data ?? [];
        });
      } else {
        flutterToastBottom(
            LocaleKeys.transactionTypeErrorMessage.tr);
      }
    }
  }
}
