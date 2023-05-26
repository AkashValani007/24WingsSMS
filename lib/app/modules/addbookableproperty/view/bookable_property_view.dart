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

import '../model/bookable_property_model.dart';
import '../viewmodel/bookable_property_viewmodel.dart';
import 'bookable_property_create.dart';

class BookablePropertyView extends StatefulWidget {
  const BookablePropertyView({Key? key}) : super(key: key);

  @override
  _BookablePropertyViewState createState() => _BookablePropertyViewState();
}

class _BookablePropertyViewState extends State<BookablePropertyView> {
  List<BookableProperty> bookablePropertyList = [];
  late BookablePropertyViewModel _service;

  UserData? userData;
  List<WingData> wingList = [];
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _service = BookablePropertyViewModel(context);
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
          LocaleKeys.amenities.tr,
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
              visible: bookablePropertyList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookablePropertyList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var data = bookablePropertyList[index];
                    return GestureDetector(
                      onTap: () {
                        Map<String, dynamic> map = {
                          'propertyData': bookablePropertyList[index],
                          'listBookableProperty': bookablePropertyList
                        };
                        Get.toNamed(Routes.BOOKING, arguments: map);
                      },
                      child:Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.sp),),),
                        elevation: 2,
                        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 17.h),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.vPropertyName ?? "",
                                          style: TextStyle(
                                            color: blackColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 25.w),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                    onTap: () async {
                                                      //BookableProperty? bookablePropertyData;
                                                      //Get.back();
                                                      Map<String, dynamic> map = {
                                                        'isEdit': true,
                                                        'data': data
                                                      };
                                                      var result = await Get.toNamed(Routes.BOOKABLE_PROPERTY,
                                                          arguments: map);
                                                      if (result != null) {
                                                        var index = bookablePropertyList.indexWhere((element) =>
                                                        element.iSBookablePropertyId == (result as BookableProperty).iSBookablePropertyId);
                                                        if (index != -1) {
                                                          setState(() {
                                                            bookablePropertyList[index] = result;
                                                          });
                                                        }
                                                      }
                                                    },
                                                  child: Image.asset(
                                                    LocaleKeys.ic_edit_two,
                                                    color: pinkColor,
                                                    fit: BoxFit.cover,
                                                    height: 22.h,
                                                    width: 22.h,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                // GestureDetector(
                                                //   onTap: () async {
                                                //     // Get.back();
                                                //     // showDeleteDialog(context, bookableProperty);
                                                //   },
                                                //   child: Image.asset(
                                                //     LocaleKeys.ic_delete,
                                                //     color: blackColor,
                                                //     fit: BoxFit.cover,
                                                //     height: 22.h,
                                                //     width: 22.h,
                                                //   ),
                                                // ),
                                              ],
                                            )),
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
            ),
            Visibility(
              visible: bookablePropertyList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    "No Amenities Found!",
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
              var result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BookablePropertyCreateView()));

               //var result = await Get.toNamed(Routes.BOOKABLE_PROPERTY);
              if (result["isSuccess"]==true) {
                setState(() {
                  print("result");
                 // bookablePropertyList.add(result);
                  getUserData();
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

  showDeleteDialog(BuildContext context, BookableProperty bookablePropertyData) {
    Widget logoutBtn = TextButton(
      child: Text(LocaleKeys.delete.tr),
      onPressed: () async {
        Get.back();
        // var deleteData =
        // await _service.deleteVehicle(bookablePropertyData.iSBookablePropertyId ?? 0);
        // if (deleteData?.isSuccess ?? false) {
        //   var index = bookablePropertyList.indexWhere(
        //           (element) => element.iSBookablePropertyId == bookablePropertyData.iSBookablePropertyId);
        //   if (index != -1) {
        //     setState(() {
        //       bookablePropertyList.removeAt(index);
        //     });
        //   }
        // }
        // flutterToastBottomGreen(deleteData?.vMessage ?? "");
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

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));

    wingList = userData!.wings;
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
    getBookableProperty();
  }

  void getBookableProperty() async {
    if (ConnectivityUtils.instance.hasInternet) {
      String vSocietyWingIds =
          wingList.map((e) => e.iSocietyWingId!).toString();
      vSocietyWingIds = vSocietyWingIds.replaceAll("(", "");
      vSocietyWingIds = vSocietyWingIds.replaceAll(")", "");
      var bookablePropertyData =
          await _service.getBookableProperty(vSocietyWingIds);
      if (bookablePropertyData?.isSuccess ?? false) {
        setState(() {
          bookablePropertyList = bookablePropertyData?.data ?? [];
        });
      } else {
        flutterToastBottom(LocaleKeys.internetMsg);
      }
    }
  }
}
