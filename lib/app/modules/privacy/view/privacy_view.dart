import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({Key? key}) : super(key: key);

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.privacyPolicy.tr,style: TextStyle(color: whiteColor,fontSize: 16.sp,fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: blackColor,
        elevation: 0,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://www.google.com/",
        onWebViewCreated: (controller) {
          this.controller = controller;
          },
      ),
    );
  }
}
