import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAdsView extends StatelessWidget {
  BannerAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      width: Get.width,
      color: whiteColor,
      height: 60.h,
      child: GestureDetector(
        onTap: () {
          _launchURL("https://www.google.com");
        },
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Image.network(
                  "https://i.picsum.photos/id/641/536/354.jpg?hmac=cPqkzpm2LhB0i0ycd3g9zfycyZVz7zD8Hls1r4toP_I",
                  fit: BoxFit.fill,
                  width: 50.w,
                  height: 50.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Swiggy",
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "Swiggy in a snack! Use Code WELLCOME50.",
                        style: TextStyle(
                          color: grayTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 30.h,
                  width: 60.w,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: button1Color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Install",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.yellow,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.h,
                ),
                child: Text(
                  "Ad",
                  style: TextStyle(
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
