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

import '../model/Support_model.dart';
import '../viewmodel/support_viewmodel.dart';

class MySupportView extends StatefulWidget {
  const MySupportView({Key? key}) : super(key: key);

  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<MySupportView> {
  List<MySupport> supportList = [];
  late SupportViewModel _service;

  UserData? userData;

  @override
  void initState() {
    super.initState();
    _service = SupportViewModel(context);
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
          LocaleKeys.support.tr,
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
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: supportList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Card(
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supportList[index].vSupportDetails ?? "",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                              ],
                            ),
                          ],
                        ),
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
        visible: userData != null &&
            (userData!.wings[0].iUserTypeId == 1 ||
                userData!.wings[0].iUserTypeId == 2),
        child: Align(
          alignment: const Alignment(0.85, 0.94),
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(Routes.SUPPORT_CREATE);
              if (result != null) {
                setState(() {
                  supportList.add(result);
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

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));

    getSupports();
  }

  void getSupports() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var supportData = await _service.getSupport(userData!.iUserId!);
      if (supportData?.isSuccess ?? false) {
        setState(() {
          supportList = supportData?.data ?? [];
        });
      } else {
        flutterToastBottom(LocaleKeys.transactionTypeErrorMessage.tr);
      }
    }
  }
}
