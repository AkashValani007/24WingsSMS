import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/vehicle/viewmodel/vehicle_viewmodel.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleView extends StatefulWidget {
  const VehicleView({Key? key}) : super(key: key);

  @override
  _VehicleViewState createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {
  List<Vehicle> vehicleList = [];
  List<Vehicle> tmpVehicleList = [];

  late VehicleViewModel _service;

  UserData? userData;

  List<WingData> wingList = [];
  WingData? wing;

  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = VehicleViewModel(context);
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
          LocaleKeys.vehicleV.tr,
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
                            hint: Text(LocaleKeys.selectWing.tr),
                            value: wing,
                            items: wingList.map((WingData value) {
                              return DropdownMenuItem<WingData>(
                                value: value,
                                child: Text(
                                  '${value.vSocietyName} - ${LocaleKeys.wing.tr} ${value.vWingName}',
                                  style:
                                  TextStyle(color: blackColor),
                                ),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                wing = value;
                                getVehicle();
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
              visible: vehicleList.isNotEmpty,
              child: Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                                hintText: LocaleKeys.search.tr,
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)))),
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
              visible: vehicleList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: vehicleList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (wing!.iUserTypeId == 1 ||
                            wing!.iUserTypeId == 2 ||
                            wing!.iUserTypeId == 3) {
                          showCustomDialog(context, vehicleList[index]);
                        } else if (vehicleList[index].iOwnerUserId == userData!.iUserId) {
                          showCustomDialog(context, vehicleList[index]);
                        }
                      },
                      child: Card(
                        elevation: 2,
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
                                margin: EdgeInsets.symmetric(vertical: 5.sp),
                                height: 50.h,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    vehicleList[index].iVehicleType == 1
                                        ? LocaleKeys.ic_bike
                                        : vehicleList[index].iVehicleType == 2
                                            ? LocaleKeys.ic_car
                                            : LocaleKeys.ic_riksa,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vehicleList[index].vVehicleNumber ?? "",
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
                                      "${vehicleList[index].vHouseNo ?? ""} - ${vehicleList[index].vOwnerName ?? ""}",
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: grayTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var url =
                                      "tel:${vehicleList[index].vMobile ?? ""}";
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
              visible: vehicleList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.noVehicleFound.tr,
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
      floatingActionButton: Align(
        alignment: const Alignment(0.85, 0.94),
        child: FloatingActionButton(
          onPressed: () async {
            var result = await Get.toNamed(Routes.VEHICLE_CREATE);
            if (result != null) {
              setState(() {
                vehicleList.add(result);
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
    );
  }

  void showCustomDialog(BuildContext context, Vehicle vehicleData) {
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
                      'vehicleData': vehicleData
                    };
                    var result = await Get.toNamed(Routes.VEHICLE_CREATE,
                        arguments: map);
                    if (result != null) {
                      var index = vehicleList.indexWhere((element) =>
                          element.iVehicleId == (result as Vehicle).iVehicleId);
                      if (index != -1) {
                        setState(() {
                          vehicleList[index] = result;
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
                    showDeleteDialog(context, vehicleData);
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



  showDeleteDialog(BuildContext context, Vehicle vehicleData) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        var deleteData =
            await _service.deleteVehicle(vehicleData.iVehicleId ?? 0);
        if (deleteData?.isSuccess ?? false) {
          var index = vehicleList.indexWhere(
              (element) => element.iVehicleId == vehicleData.iVehicleId);
          if (index != -1) {
            setState(() {
              vehicleList.removeAt(index);
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
      content: Text(LocaleKeys.deleteMessageVehicle.tr),
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

  void filterSearchResults(String query) {
    List<Vehicle> dummySearchList = <Vehicle>[];
    dummySearchList.addAll(tmpVehicleList);
    if (query.isNotEmpty) {
      List<Vehicle> dummyListData = <Vehicle>[];
      for (var item in dummySearchList) {
        if (item.vVehicleNumber!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        vehicleList.clear();
        vehicleList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        vehicleList.clear();
        vehicleList.addAll(tmpVehicleList);
      });
    }
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));

    wingList = userData!.wings;
    setState(() {
      wing = wingList[0];
    });
    getVehicle();
  }

  void getVehicle() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var vehicleData = await _service.getVehicle(wing!.iSocietyWingId!);
      if (vehicleData?.isSuccess ?? false) {
        setState(() {
          vehicleList = vehicleData?.data ?? [];
        });
        tmpVehicleList.clear();
        tmpVehicleList.addAll(vehicleList);
      } else {

        flutterToastBottom(
            LocaleKeys.internetMsg.tr);

      }
    }
  }
}
