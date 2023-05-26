import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  _LanguageViewState createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  var language = "en";

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.language.tr,
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("vLanguage", language);
                var isLogin = prefs.getBool("isLogin");
                if (isLogin == null) {
                  Get.offNamed(Routes.LOGIN);
                } else if (isLogin) {
                  Get.offNamed(Routes.HOME);
                } else {
                  Get.offNamed(Routes.LOGIN);
                }
                var locale = await getLocale();
                Get.updateLocale(locale);
              },
              child: Text(
                LocaleKeys.save.tr,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            RadioListTile(
              title: Text(
                "English",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 14.sp,
                ),
              ),
              value: "en",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = "en";
                });
              },
            ),
            RadioListTile(
              title: Text(
                "Gujarati",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 14.sp,
                ),
              ),
              value: "gu",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = "gu";
                });
              },
            ),
            RadioListTile(
              title: Text(
                "Hindi",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 14.sp,
                ),
              ),
              value: "hi",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = "hi";
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString("vLanguage")??"en";
      print('LANGUAGE ===========${language}');
    });
  }
}
