import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class InterstitialAdsView extends StatefulWidget {
  const InterstitialAdsView({Key? key}) : super(key: key);

  @override
  _InterstitialAdsViewState createState() => _InterstitialAdsViewState();
}

class _InterstitialAdsViewState extends State<InterstitialAdsView> {
  // late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
   /* _controller = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });*/
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: whiteColor,
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _launchURL("https://www.google.com");
                        Get.back();
                      },
                      child: Image.network(
                        "https://i.picsum.photos/id/641/536/354.jpg?hmac=cPqkzpm2LhB0i0ycd3g9zfycyZVz7zD8Hls1r4toP_I",
                        fit: BoxFit.fill,
                        width: Get.width,
                        height: 200.h,
                      ),
                    ),
                    /*Center(
                      child: _controller.value.isInitialized
                          ? SizedBox(
                        height: 200.h,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                          : SizedBox(
                        height: 200.h,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.w,
                        top: 10.h,
                      ),
                      padding: EdgeInsets.all(4.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          LocaleKeys.ic_close,
                          width: 24.w,
                          height: 24.w,
                          color: closeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _launchURL("https://www.google.com");
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recipes by Desserts Corner",
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 30.sp,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "Learn how to bake all your favorite desserts at home",
                            style: TextStyle(
                              color: grayTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 22.sp,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "Cadbury Desserts Corner",
                            style: TextStyle(
                              color: grayTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 22.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  height: 1,
                  color: hintColor,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL("https://www.google.com");
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                        child: Text(
                          "Learn More",
                          style: TextStyle(
                            color: button1Color,
                            fontWeight: FontWeight.w500,
                            fontSize: 26.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Image.asset(
                        LocaleKeys.ic_next,
                        width: 20.w,
                        color: button1Color,
                        height: 20.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
