import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    ConnectivityUtils.instance.init();
    checkIsLogin();
    Timer(const Duration(seconds: 3), () => {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        ),
      ),
    );
  }

  void checkIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.getBool("isLogin");
    var isLanguage = prefs.getString("vLanguage");
    Timer(const Duration(seconds: 3), () {
      if (isLanguage == null) {
        Get.offNamed(Routes.LANGUAGE_VIEW);
      } else {
        if (isLogin == null) {
          Get.offNamed(Routes.LOGIN);
        } else if (isLogin) {
          Get.offNamed(Routes.HOME);
        } else {
          Get.offNamed(Routes.LOGIN);
        }
      }
    });
  }
}
