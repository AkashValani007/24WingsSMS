import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/generated/locales.g.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        iconTheme: IconThemeData(
          color: blackColor, //change your color here
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.notification.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  LocaleKeys.ic_filter,
                  fit: BoxFit.cover,
                  height: 18.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: homeCardBack,
                    border: Border.all(
                      color: cardBorder,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.sp),
                        width: 56.w,
                        height: 50.h,
                        child: GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              LocaleKeys.ic_dummy_user,
                              fit: BoxFit.cover,
                            ),
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
                            "Samantha Smith",
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                            LocaleKeys.viewProfile.tr,
                            style: TextStyle(
                              color: grayColor,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
