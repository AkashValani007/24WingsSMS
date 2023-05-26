import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/app/modules/watchmen/viewmodel/watchmen_viewmodel.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import '../../../widget/custom_button.dart';

class WatchmenCreateView extends StatefulWidget {
  const WatchmenCreateView({Key? key}) : super(key: key);

  @override
  _WatchmenCreateViewState createState() => _WatchmenCreateViewState();
}

class _WatchmenCreateViewState extends State<WatchmenCreateView> {
  List<String> watchmenList = [
    LocaleKeys.day.tr,
    LocaleKeys.night.tr,
    LocaleKeys.full.tr
  ];
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var addressController = TextEditingController();
  String? watchmenType = LocaleKeys.day.tr;

  late WatchmenViewModel _service;
  dynamic arguments = Get.arguments;
  bool isEdit = false;
  WatchmenData? watchmenData;

  @override
  void initState() {
    super.initState();
    _service = WatchmenViewModel(context);
    if (arguments != null) {
      isEdit = arguments['isEdit'];
      watchmenData = arguments['watchmenData'];
    }
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
          isEdit ? LocaleKeys.editWatchmen.tr : LocaleKeys.addWatchmen.tr,
          style: TextStyle(color: blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 14.h,
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
                            LocaleKeys.watchmenTime.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          DropdownButton<String>(
                            hint: Text(LocaleKeys.watchmenTimeHint.tr),
                            value: watchmenType,
                            items: watchmenList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                watchmenType = value ?? "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            LocaleKeys.watchmenName.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.watchmenNameHint.tr,
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
                            LocaleKeys.watchmenNumber.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.watchmenNumberHint.tr,
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
                            LocaleKeys.watchmenAddress.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.watchmenAddressHint.tr,
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
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          var name = nameController.text;
                          var mobileNumber = mobileController.text;
                          var address = addressController.text;
                          if (name.isEmpty) {
                            return;
                          }
                          if (mobileNumber.isEmpty) {
                            return;
                          }
                          if (address.isEmpty) {
                            return;
                          }
                          if (watchmenType!.isEmpty) {
                            return;
                          }
                          var type = watchmenType == LocaleKeys.day.tr
                              ? 0
                              : watchmenType == LocaleKeys.night.tr
                                  ? 1
                                  : 2;
                          if (ConnectivityUtils.instance.hasInternet) {
                            if (isEdit) {
                              var createData = await _service.updateWatchmen(
                                  watchmenData?.iWatchmenId ?? 0,
                                  name,
                                  mobileNumber,
                                  address,
                                  type,
                                  watchmenData?.iOnDuty ?? 0);
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }

                              flutterToastBottomGreen(createData?.vMessage ?? "");
                            } else {
                              var createData = await _service.createWatchmen(
                                  name, mobileNumber, address, type);
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }

                              flutterToastBottomGreen(createData?.vMessage ?? "");
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
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setData() {
    watchmenType = watchmenData?.vWatchmenType == 0
        ? LocaleKeys.day.tr
        : watchmenData?.vWatchmenType == 1
            ? LocaleKeys.night.tr
            : LocaleKeys.full.tr;
    nameController.text = watchmenData?.vWatchmenName ?? "";
    mobileController.text = watchmenData?.vWatchmenNumber ?? "";
    addressController.text = watchmenData?.vWatchmenAddress ?? "";
  }
}
