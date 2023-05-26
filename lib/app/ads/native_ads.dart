import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeAdsView extends StatefulWidget {
  const NativeAdsView({Key? key}) : super(key: key);

  @override
  _NativeAdsViewState createState() => _NativeAdsViewState();
}

class _NativeAdsViewState extends State<NativeAdsView> {
  // late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    /*_controller = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });*/
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      height: 260.h,
      color: whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL("https://www.google.com");
                },
                child: Image.network(
                  "https://i.picsum.photos/id/641/536/354.jpg?hmac=cPqkzpm2LhB0i0ycd3g9zfycyZVz7zD8Hls1r4toP_I",
                  fit: BoxFit.fill,
                  width: Get.width,
                  height: 200.h,
                ),
              ),
              /* Center(
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
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  color: Colors.yellow,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  child: Text(
                    "Ad",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _launchURL("https://www.google.com");
            },
            child: Container(
              width: Get.width,
              color: whiteColor,
              height: 60.h,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
            ),
          ),
        ],
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
