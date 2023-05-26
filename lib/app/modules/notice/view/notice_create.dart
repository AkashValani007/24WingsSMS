import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/notice/model/notice_model.dart';
import 'package:maintaince/app/modules/notice/viewmodel/notice_viewmodel.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';
import '../../home/model/constant_model.dart';

class NoticeCreateView extends StatefulWidget {
  const NoticeCreateView({Key? key}) : super(key: key);

  @override
  _NoticeCreateViewState createState() => _NoticeCreateViewState();
}

class _NoticeCreateViewState extends State<NoticeCreateView> {
  Notice? noticeData;
  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  var detailsController = TextEditingController();

  dynamic arguments = Get.arguments;
  bool isEdit = false;

  late NoticeViewModel _service;

  @override
  void initState() {
    super.initState();
    _service = NoticeViewModel(context);
    if (arguments != null) {
      isEdit = arguments['isEdit'];
      noticeData = arguments['noticeData'];
    }
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
          isEdit ? LocaleKeys.editNotice.tr : LocaleKeys.addNoticeV.tr,
          style: TextStyle(color: blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: wingList.length != 1,
                child: SizedBox(
                  height: 10.h,
                ),
              ),
              Visibility(
                visible: wingList.length != 1,
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.selectWingG.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            wingList.isEmpty
                                ? Container()
                                : DropdownButton<WingData>(
                                    hint: Text(LocaleKeys.selectWing.tr),
                                    value: wing,
                                    items: wingList.map((WingData value) {
                                      return DropdownMenuItem<WingData>(
                                        value: value,
                                        child: Text(
                                          '${value.vSocietyName} - ${LocaleKeys.wing.tr} ${value.vWingName}',
                                          style: TextStyle(color: blackColor),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        wing = value;
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                            LocaleKeys.noticeDetails.tr,
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
                              hintText: LocaleKeys.noticeDetailsHint.tr,
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
                            var details = detailsController.text.toString();

                            if (details.isEmpty) {
                              return;
                            }
                            if (ConnectivityUtils.instance.hasInternet) {
                              if (isEdit) {
                                var createData = await _service.updateNotice(
                                    noticeData?.iNoticeId ?? 0, details);
                                if (createData?.isSuccess ?? false) {
                                  Get.back(result: createData?.data);
                                }

                                flutterToastBottomGreen(
                                    createData?.vMessage ?? "");
                              } else {
                                var createData = await _service.createNotice(
                                  userData!.iUserId!,
                                  wing!.iSocietyWingId!,
                                  details,
                                );
                                if (createData?.isSuccess ?? false) {
                                  Get.back(result: createData?.data);
                                }

                                flutterToastBottomGreen(
                                    createData?.vMessage ?? "");
                              }
                            } else {
                              flutterToastBottom(LocaleKeys.internetMsg);
                            }
                          },
                          child: CustomButton(
                            height: 39.h,
                            width: Get.width,
                            text: isEdit
                                ? LocaleKeys.update.tr
                                : LocaleKeys.save.tr,
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
                          //       isEdit ? LocaleKeys.update.tr : LocaleKeys.save.tr,
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
    wingList = userData!.wings;
    wing = wingList[0];

    setState(() {});
    setData();
  }

  void setData() {
    detailsController.text = noticeData?.vNoticeDetail ?? "";
  }
}
