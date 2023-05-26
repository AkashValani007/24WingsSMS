import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';
import '../model/support_model.dart';
import '../viewmodel/support_viewmodel.dart';

class SupportCreateView extends StatefulWidget {
  const SupportCreateView({Key? key}) : super(key: key);

  @override
  _SupportCreateViewState createState() => _SupportCreateViewState();
}

class _SupportCreateViewState extends State<SupportCreateView> {
  MySupport? supportData;
  UserData? userData;

  var detailsController = TextEditingController();

  dynamic arguments = Get.arguments;

  late SupportViewModel _service;

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
          LocaleKeys.addSupportV.tr,
          style: TextStyle(color: blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.enterMessage.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: detailsController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.enterMessageHint.tr,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          var details = detailsController.text;

                          if (details.isEmpty) {
                            return;
                          }
                          if (ConnectivityUtils.instance.hasInternet) {
                            var createData = await _service.createSupport(
                              userData!.iUserId!,
                              details,
                            );
                            if (createData?.isSuccess ?? false) {
                              Get.back(result: createData?.data);
                            }

                            flutterToastBottomGreen(
                                createData?.vMessage ?? "");
                          } else {

                            flutterToastBottom(
                                LocaleKeys.internetMsg);

                          }
                        },

                        child: CustomButton(
                          height: 39.h,
                          width: Get.width,
                          text: LocaleKeys.save.tr,
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          variant: ButtonVariant.OutlinePink8004c,
                          padding: ButtonPadding.PaddingAll10,
                          fontStyle: ButtonFontStyle.RobotoRomanSemiBold18,
                          alignment: Alignment.bottomCenter,
                        ),
                        // child: Container(
                        //   height: 40.h,
                        //   margin: EdgeInsets.symmetric(horizontal: 16.w),
                        //   decoration: BoxDecoration(
                        //       color: blackColor,
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10))),
                        //   child: Center(
                        //     child: Text(
                        //       LocaleKeys.save.tr,
                        //       style: TextStyle(
                        //         color: whiteColor,
                        //         fontSize: 16.sp,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserData() async {
    if (userData == null) {
      final prefs = await SharedPreferences.getInstance();
      userData =
          UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    }
    setState(() {});
  }
}
