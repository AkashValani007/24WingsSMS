import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/password/viewmodel/change_password_viewmodel.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';

import '../../../widget/custom_button.dart';

class PasswordChangeView extends StatefulWidget {
  const PasswordChangeView({Key? key}) : super(key: key);

  @override
  _PasswordChangeViewState createState() => _PasswordChangeViewState();
}

class _PasswordChangeViewState extends State<PasswordChangeView> {
  late ChangePasswordViewModel _service;

  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var confPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = ChangePasswordViewModel(context);
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
          LocaleKeys.changePasswordV.tr,
          style: TextStyle(color: blackColor),
        ),
      ),
      body: SafeArea(
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
                          LocaleKeys.oldPassword.tr,
                          style:
                              TextStyle(fontSize: 16.sp, color: grayTextColor),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        TextField(
                          controller: oldPassController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: hintColor),
                            hintText: LocaleKeys.oldPasswordHint.tr,
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
              height: 20.h,
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
                          LocaleKeys.newPassword.tr,
                          style:
                              TextStyle(fontSize: 16.sp, color: grayTextColor),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        TextField(
                          controller: newPassController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: hintColor),
                            hintText: LocaleKeys.newPasswordHint.tr,
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
              height: 20.h,
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
                          LocaleKeys.reNewPassword.tr,
                          style:
                              TextStyle(fontSize: 16.sp, color: grayTextColor),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        TextField(
                          controller: confPassController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: hintColor),
                            hintText: LocaleKeys.reNewPasswordHint.tr,
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () async {
                        var oldPass = oldPassController.text;
                        var newPass = newPassController.text;
                        var confPass = confPassController.text;
                        if (oldPass.isEmpty) {
                          return;
                        }
                        if (newPass.isEmpty) {
                          return;
                        }
                        if (confPass.isEmpty) {
                          return;
                        }
                        if (newPass != confPass) {
                          return;
                        }
                        if (ConnectivityUtils.instance.hasInternet) {
                          var createData =
                              await _service.changePassword(oldPass, newPass);
                          if (createData?.isSuccess ?? false) {
                            Get.back();
                            flutterToastBottomGreen(
                              createData?.vMessage ?? "");

                          } else {
                            flutterToastBottomGreen(
                                createData?.vMessage ?? "");
                          }
                        } else {
                          flutterToastBottom(
                              LocaleKeys.internetMsg.tr);
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
                      )
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
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
