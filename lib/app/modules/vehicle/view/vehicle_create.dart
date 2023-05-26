import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/home/model/constant_model.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/vehicle/viewmodel/vehicle_viewmodel.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';

class VehicleCreateView extends StatefulWidget {
  const VehicleCreateView({Key? key}) : super(key: key);

  @override
  _VehicleCreateViewState createState() => _VehicleCreateViewState();
}

class _VehicleCreateViewState extends State<VehicleCreateView> {
  List vehicleType = [];

  var numberController = TextEditingController();

  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  ConstantData? constant;
  VehicleTypeData? value;

  late VehicleViewModel _service;
  dynamic arguments = Get.arguments;
  bool isEdit = false;
  Vehicle? vehicleData;

  var languageS = PreferenceManager.getString("vLanguage");

  @override
  void initState() {
    super.initState();
    _service = VehicleViewModel(context);
    if (arguments != null) {
      isEdit = arguments['isEdit'];
      vehicleData = arguments['vehicleData'];
    }
    getUserData();
    getConstantData();
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
          isEdit ? LocaleKeys.editVehicle.tr : LocaleKeys.addVehicle.tr,
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
                height: 10.h,
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
                            LocaleKeys.vehicleType.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          constant == null
                              ? Container()
                              : DropdownButton<VehicleTypeData>(
                                  hint: Text(LocaleKeys.vehicleSelectHint.tr),
                                  value: value,
                                  items: constant!.tblVehicleTypeMaster
                                      ?.map((VehicleTypeData value) {
                                    return DropdownMenuItem<VehicleTypeData>(
                                      value: value,
                                      child: languageS == "gu"
                                          ? Text(value.vVehicleName_gj ?? "")
                                          : languageS == "hi"
                                              ? Text(
                                                  value.vVehicleName_hi ?? "")
                                              : Text(value.vVehicleName ?? ""),

                                      //Text(value.vVehicleName ?? ""),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (values) {
                                    setState(() {
                                      value = values;
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
                            LocaleKeys.vehicleNumber.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: numberController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.vehicleNumberHint.tr,
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
                          var number = numberController.text;
                          if (number.isEmpty) {
                            return;
                          }
                          if (value == null) {
                            return;
                          }
                          if (ConnectivityUtils.instance.hasInternet) {
                            if (isEdit) {
                              var createData = await _service.updateVehicle(
                                  vehicleData?.iVehicleId ?? 0,
                                  value?.iVehicleType ?? 0,
                                  number);
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }

                              flutterToastBottomGreen(createData?.vMessage ?? "");
                            } else {
                              var createData = await _service.createVehicle(
                                  wing!.iUserWingId!,
                                  value?.iVehicleType ?? 0,
                                  number);
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

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));

    wingList = userData!.wings;
    wing = wingList[0];
  }

  void getConstantData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      constant = ConstantData.fromJson(
          jsonDecode(prefs.getString("constantData") ?? ""));
    });
    setData();
  }

  void setData() {
    var selectType = constant?.tblVehicleTypeMaster!
        .where((element) => element.iVehicleType == vehicleData?.iVehicleType)
        .toList();
    if (selectType!.isNotEmpty) {
      value = selectType[0];
    }
    numberController.text = vehicleData?.vVehicleNumber ?? "";
  }
}
