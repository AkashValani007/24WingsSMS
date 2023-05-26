import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/viewmodel/login_viewmodel.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel _service;

  var isPassHide = true;

  var mobileController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = LoginViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          LocaleKeys.ic_app_icon,
                          height: 80.h,
                          width: 80.w,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
                          child: Text(
                            LocaleKeys.appName.tr,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.h,
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
                              LocaleKeys.phoneNumber.tr,
                              style:
                                  TextStyle(fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              decoration: InputDecoration(
                                counterText: "",
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.phoneNumberHint.tr,
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.password.tr,
                              style:
                                  TextStyle(fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              maxLength: 10,
                              obscureText: isPassHide,
                              // validator: (value) {
                              //   if(value!.isEmpty) {
                              //     return ("password cannot be empty");
                              //   }
                              //   else if (value.length < 6) {
                              //     return 'Password must be of 6 to 10 digit';
                              //   }
                              //   return null;
                              // },
                              decoration: InputDecoration(
                                counterText: "",
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.passwordHint.tr,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  child: Image.asset(isPassHide
                                      ? LocaleKeys.ic_pass_show
                                      : LocaleKeys.ic_pass_hide),
                                  onTap: () {
                                    setState(() {
                                      isPassHide = !isPassHide;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                //   child: Container(
                //     //margin: EdgeInsets.symmetric(horizontal: 2),
                //     decoration: const BoxDecoration(color: Colors.white),
                //     //padding: const EdgeInsets.all(15),
                //     child:TextFormField(
                //       decoration: InputDecoration(
                //         contentPadding: const EdgeInsets.all(15),
                //         labelText: "Password",
                //         labelStyle: TextStyle(color: hintColor),
                //         enabledBorder:  OutlineInputBorder(
                //           borderSide: BorderSide(color: blackColor,width: 1.5),
                //         ),
                //         focusedBorder:  OutlineInputBorder(
                //           borderSide: BorderSide(color: blackColor,width: 1.5),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        child: Text(
                          LocaleKeys.forgotPassword.tr,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacyView()));
                        Get.toNamed(Routes.PRIVACY_POLICY);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16.w),
                        child: Text(
                          LocaleKeys.privacyPolicy.tr,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          var mobileNumber = mobileController.text;
                          var password = passwordController.text;

                          if (mobileController.value.text.isEmpty) {
                            flutterToastTop(LocaleKeys.errorMobileNoMessage.tr);
                            return;
                          }
                          if (mobileController.value.text.length != 10) {
                            flutterToastTop(LocaleKeys.errorMobileValidMessage.tr);
                            return;
                          }
                          if (password.isEmpty) {
                            flutterToastTop(LocaleKeys.errorPasswordMessage.tr);
                            return;
                          }
                          if (ConnectivityUtils.instance.hasInternet) {
                            var loginData =
                                await _service.login(mobileNumber, password);
                            if (loginData?.isSuccess ?? false) {
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool("isLogin", true);
                              prefs.setString(
                                  "userData", jsonEncode(loginData?.data));
                              PreferenceManager.putString("userData",jsonEncode(loginData?.data));
                              prefs.setString(
                                  "token", loginData?.data?.token ?? "");

                              Get.offNamed(Routes.HOME);
                            } else {
                              flutterToastTop(loginData?.vMessage ?? "");
                            }
                          } else {
                            flutterToastTop(LocaleKeys.internetMsg);
                          }
                        },
                        child: CustomButton(
                          height: 39.h,
                          width: Get.width,
                          text: LocaleKeys.loginName.tr,
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          variant: ButtonVariant.OutlinePink8004c,
                          padding: ButtonPadding.PaddingAll10,
                          fontStyle:
                          ButtonFontStyle.RobotoRomanSemiBold18,
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
                        //       LocaleKeys.loginName.tr,
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
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(left: 16.w, right: 5.w),
                        child: Text(
                          LocaleKeys.register1.tr,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER_VIEW);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        child: Text(
                          LocaleKeys.register2.tr,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
