import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/viewmodel/user_viewmodel.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<User> userList = []; //
  late UserViewModel _service;

  List<WingData> wingList = [];
  WingData? wing;
  UserData? userData; //

  @override
  void initState() {
    super.initState();
    _service = UserViewModel(context);
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
          LocaleKeys.members.tr,
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
                            LocaleKeys.selectWingG.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          wingList.isEmpty
                              ? Container()
                              : DropdownButton<WingData>(
                            hint: Text( LocaleKeys.selectWing.tr),
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
                                getUser();
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
            SizedBox(
              height: 10.h,
            ),
            Visibility(
              visible: userList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: userList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (wing?.iUserTypeId == 1 || wing?.iUserTypeId == 2 || wing?.iUserTypeId == 3) {
                          showCustomDialog(context, userList[index]);
                        }
                      },
                      child: Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.sp),
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(
                                    LocaleKeys.ic_dummy_user,
                                    fit: BoxFit.cover,
                                  ),
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
                                      userList[index].iUserId ==
                                              userData!.iUserId
                                          ? LocaleKeys.you.tr
                                          : userList[index].vUserName ?? "",
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
                                      "${LocaleKeys.mobileNo.tr} : ${userList[index].vMobile ?? ""}",
                                      style: TextStyle(
                                        color: grayColor,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "${LocaleKeys.flatNo.tr} ${userList[index].vHouseNo ?? ""}",
                                      style: TextStyle(
                                        color: grayColor,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var url =
                                      "tel:${userList[index].vMobile ?? ""}";
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
              visible: userList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.noMemberFound.tr,
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
        visible: wing?.iUserTypeId == 1 || wing?.iUserTypeId == 2 || wing?.iUserTypeId == 3,
        child: Align(
          alignment: const Alignment(0.85, 0.94),
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(Routes.USER_CREATE);
              if (result != null) {
                setState(() {
                  userList.add(result);
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

  void showCustomDialog(BuildContext context, User userDataItem) {
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
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () async {
                    Get.back();
                    Map<String, dynamic> map = {
                      'isEdit': true,
                      'userData': userDataItem
                    };
                    print("userDataItem${userDataItem.iUserId}");
                    var result = await Get.toNamed(Routes.USER_CREATE, arguments: {
                      'isEdit': true,
                      'userData': userDataItem
                    });
                    if (result != null) {
                      var index = userList.indexWhere((element) => element.iUserId == (result as UserData).iUserId);
                      if (index != -1) {
                        setState(() {
                          userList[index] = result;
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
                if (userDataItem.iUserId != userData!.iUserId)
                  SizedBox(height: 16.h),
                if (userDataItem.iUserId != userData!.iUserId)
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                      showDeleteDialog(context, userDataItem);
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

  showDeleteDialog(BuildContext context, User userDataItem) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        var deleteData = await _service.deleteUser(userDataItem.iUserId ?? 0);
        if (deleteData?.isSuccess ?? false) {
          var index = userList
              .indexWhere((element) => element.iUserId == userDataItem.iUserId);
          if (index != -1) {
            setState(() {
              userList.removeAt(index);
            });
          }
        }
        flutterToastBottom(deleteData?.vMessage ?? "");
      },
    );
    Widget cancelBtn = TextButton(
      child: Text(LocaleKeys.logoutCancelMessage.tr),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text(LocaleKeys.deleteMessageMember.tr),
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
    getUser();
  }

  void getUser() async {
    if (ConnectivityUtils.instance.hasInternet) {
      final prefs = await SharedPreferences.getInstance();
      var database = await databaseInitialise();
      var tempList = await database.userDao.findWingAllUsers(wing!.iSocietyWingId!);
      setState(() {
        userList = tempList;
      });
      var userData = await _service.getUser(wing!.iSocietyWingId!);
      if (userData?.isSuccess ?? false) {
        prefs.setInt("user_timestamp_${wing!.iSocietyWingId!}", DateTime.now().toUtc().millisecondsSinceEpoch);
        setState(() {
          userList.addAll(userData?.data ?? []);
        });
        if (userData?.data != null && userData!.data!.isNotEmpty) {
          database.userDao.insertUserMultiple(userData.data!);
        }
      } else {
        flutterToastBottom(LocaleKeys.internetMsg);
      }
    }
  }
}
