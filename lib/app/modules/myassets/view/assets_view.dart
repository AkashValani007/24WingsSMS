import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/assets_model.dart';
import '../viewmodel/assets_viewmodel.dart';

class AssetsView extends StatefulWidget {
  const AssetsView({Key? key}) : super(key: key);

  @override
  _AssetsViewState createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
  List<AssetModel> assetsList = [];
  late AssetsViewModel _service;

  List<WingData> wingList = [];
  WingData? wing;
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _service = AssetsViewModel(context);
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
          LocaleKeys.asset.tr,
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
                                        '${value.vSocietyName} - ${LocaleKeys.wing.tr} ${value.vWingName}',
                                        style: TextStyle(color: blackColor),
                                      ),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      wing = value;
                                      getAssets();
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
              visible: assetsList.isEmpty,
              child: Expanded(
                flex: 7,
                child: Center(
                  child: Text(
                    LocaleKeys.noAssetsFound.tr,
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
                itemCount: assetsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (wing!.iUserTypeId == 1 ||
                          wing!.iUserTypeId == 2 ||
                          wing!.iUserTypeId == 3) {
                        showCustomDialog(context, assetsList[index]);
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.sp),
                        ),
                      ),
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 4.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17.w, vertical: 17.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        assetsList[index].vAssetName ?? "",
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        assetsList[index].iQty.toString(),
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 3.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.sp),
                                bottomLeft: Radius.circular(6.sp),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                        ],
                      ),
                    ),
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
              var result = await Get.toNamed(Routes.ASSET_CREATE);
              if (result != null) {
                setState(() {
                  assetsList.add(result);
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

  void showCustomDialog(BuildContext context, AssetModel assetModel) {
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
                      'AssetsData': assetModel
                    };
                    var result =
                        await Get.toNamed(Routes.ASSET_CREATE, arguments: map);
                    if (result != null) {
                      var index = assetsList.indexWhere((element) =>
                          element.iAssetsId ==
                          (result as AssetModel).iAssetsId);
                      if (index != -1) {
                        setState(() {
                          assetsList[index] = result;
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
                    showDeleteDialog(context, assetModel);
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

  showDeleteDialog(BuildContext context, AssetModel assetModel) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        var deleteData = await _service.deleteAssets(assetModel.iAssetsId ?? 0);
        if (deleteData?.isSuccess ?? false) {
          var index = assetsList.indexWhere(
              (element) => element.iAssetsId == assetModel.iAssetsId);
          if (index != -1) {
            setState(() {
              assetsList.removeAt(index);
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
      content: Text(LocaleKeys.deleteMessageAssets.tr),
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
    getAssets();
  }

  void getAssets() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var assetsData = await _service.getAssets(wing!.iSocietyWingId!);
      if (assetsData?.isSuccess ?? false) {
        setState(() {
          assetsList = assetsData?.data ?? [];
        });
      } else {
        flutterToastBottom(LocaleKeys.internetMsg.tr);
      }
    }
  }
}
