import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';
import '../model/assets_model.dart';
import '../viewmodel/assets_viewmodel.dart';

class AssetsCreateView extends StatefulWidget {
  const AssetsCreateView({Key? key}) : super(key: key);

  @override
  _AssetsCreateViewState createState() => _AssetsCreateViewState();
}

class _AssetsCreateViewState extends State<AssetsCreateView> {
  AssetModel? assetsData;
  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  var detailsController = TextEditingController();
  var vQtyController = TextEditingController();

  dynamic arguments = Get.arguments;
  bool isEdit = false;

  late AssetsViewModel _service;

  @override
  void initState() {
    super.initState();
    _service = AssetsViewModel(context);
    if (arguments != null) {
      isEdit = arguments['isEdit'];
      assetsData = arguments['AssetsData'];
    }
      getUserData();
    setData();
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
          isEdit ? LocaleKeys.editAssets.tr : LocaleKeys.addAssetsV.tr,
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
                              LocaleKeys.selectWing.tr,
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
                                    '${value.vSocietyName} - ${ LocaleKeys.wing.tr} ${value.vWingName}',
                                    style:
                                    TextStyle(color: blackColor),
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
                            LocaleKeys.assetsDetails.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: detailsController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.assetsDetailsHint.tr,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.qty.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: vQtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.qtyHint.tr,
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
                          var details = detailsController.text;
                          //int Qty = int.parse(vQtyController.text);
                          var vQty = vQtyController.text;

                          if (details.isEmpty) {
                            return;
                          }
                          if (vQtyController.text.isEmpty) {
                            return;
                          }
                          if (ConnectivityUtils.instance.hasInternet) {
                            if (isEdit) {
                              var createData = await _service.updateAssets(
                                  assetsData?.iAssetsId ?? 0,
                                  details,
                                  vQty);
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }
                              flutterToastBottomGreen(
                                  createData?.vMessage ?? "");

                            } else {
                              var createData = await _service.createAsset(
                                userData!.iUserId?.toInt()??0,
                                wing!.iSocietyWingId?.toInt()??0,
                                details,
                                vQty,
                              );
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }
                              flutterToastBottomGreen(
                                  createData?.vMessage ?? "");
                            }
                          } else {

                            flutterToastBottomGreen(
                                LocaleKeys.internetMsg.tr);
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
    detailsController.text = assetsData?.vAssetName ?? "";
    vQtyController.text = assetsData?.iQty ?? "";
  }


}
