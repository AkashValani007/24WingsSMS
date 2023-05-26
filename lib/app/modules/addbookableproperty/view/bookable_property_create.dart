import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/addbookableproperty/model/bookable_property_model.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';
import '../../home/model/constant_model.dart';
import '../viewmodel/bookable_property_viewmodel.dart';

class BookablePropertyCreateView extends StatefulWidget {
  const BookablePropertyCreateView({Key? key}) : super(key: key);

  @override
  _BookablePropertyCreateViewState createState() =>
      _BookablePropertyCreateViewState();
}

class _BookablePropertyCreateViewState
    extends State<BookablePropertyCreateView> {
  dynamic arguments = Get.arguments;
  ConstantData? constant;

  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  List<User> userList = [];
  User? selectUser;

  var propertyNameController = TextEditingController();

  bool isEdit = false;

  List<dynamic> selectedWingList = [];

  late BookablePropertyViewModel _service;
  BookableProperty? data;

  @override
  void initState() {
    super.initState();
    _service = BookablePropertyViewModel(context);
    if (arguments != null) {
      isEdit = arguments['isEdit'];
      data = arguments['data'];
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
          isEdit
              ? LocaleKeys.editBookableProperty.tr
              : LocaleKeys.createBookableProperty.tr,
          style: TextStyle(color: blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            child: Column(
              children: [
                Visibility(
                  visible: wingList.length != 1,
                  child: SizedBox(
                    height: 10.h,
                  ),
                ),
                // Visibility(
                //   visible: wingList.length != 1,
                //   child: Container(
                //     margin: EdgeInsets.only(left: 16.w, right: 16.w),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Select Wing*",
                //                 style: TextStyle(
                //                     fontSize: 16.sp, color: grayTextColor),
                //               ),
                //               SizedBox(
                //                 height: 6.h,
                //               ),
                //               wingList.isEmpty
                //                   ? Container()
                //                   : DropdownButton<WingData>(
                //                       hint: const Text("Select Wing"),
                //                       value: wing,
                //                       items: wingList.map((WingData value) {
                //                         return DropdownMenuItem<WingData>(
                //                           value: value,
                //                           child: Text(
                //                             '${value.vSocietyName} - Wing ${value.vWingName}',
                //                             style: TextStyle(color: blackColor),
                //                           ),
                //                         );
                //                       }).toList(),
                //                       isExpanded: true,
                //                       onChanged: (value) {
                //                         setState(() {
                //                           wing = value;
                //                         });
                //                       },
                //                     ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                              LocaleKeys.whoAccessProperty.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            GFMultiSelect(
                              items: wingList.map((e) => e.vWingName!).toList(),
                              onSelect: (value) {
                                selectedWingList = value;
                              },
                              dropdownTitleTileText: LocaleKeys.selectWing.tr,
                              dropdownTitleTileColor: greyBackground,
                              // dropdownTitleTileMargin: const EdgeInsets.only(
                              //     top: 22, left: 18, right: 18, bottom: 5),
                              // dropdownTitleTilePadding:
                              //     const EdgeInsets.all(10),
                              dropdownUnderlineBorder: const BorderSide(
                                  color: Colors.transparent, width: 2),
                              dropdownTitleTileBorder:
                                  Border.all(color: greyBackground, width: 1),
                              dropdownTitleTileBorderRadius:
                                  BorderRadius.circular(5),
                              expandedIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                              ),
                              collapsedIcon: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.black54,
                              ),

                              submitButton: Text(LocaleKeys.oK.tr),
                              cancelButton: Text(LocaleKeys.cancelC.tr),
                              dropdownTitleTileTextStyle: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.all(1),
                              type: GFCheckboxType.basic,
                              activeBgColor: whiteColor,
                              activeBorderColor: blackColor,
                              inactiveBorderColor: blackColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                              LocaleKeys.propertyName.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: propertyNameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLength: 20,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.propertyNameHint.tr,
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            var vPropertyName = propertyNameController.text;
                            if (selectedWingList.isEmpty) {
                              return;
                            }
                            if (vPropertyName.isEmpty) {
                              return;
                            }

                            if (ConnectivityUtils.instance.hasInternet) {
                              if (isEdit) {
                                var createData = await _service.updateBookableProperty(
                                    data?.iSBookablePropertyId ?? 0,
                                    vPropertyName);
                                if (createData?.isSuccess ?? false) {
                                  Get.back(result: createData?.data);
                                }
                                flutterToastBottomGreen(
                                  createData?.vMessage ?? "",
                                );
                              } else {
                                String vSocietyWingIds = "";
                                for (var element in selectedWingList) {
                                  vSocietyWingIds +=
                                      ",${wingList[int.parse(element.toString())].iSocietyWingId!}";
                                }
                                vSocietyWingIds =
                                    vSocietyWingIds.replaceFirst(",", "");

                                var createData = await _service.createBookableProperty(
                                  wing?.iSocietyId ?? 0,
                                  userData?.iUserId ?? 0,
                                  vSocietyWingIds,
                                  vPropertyName,
                                );
                                if (createData?.isSuccess ?? false) {
                                  Navigator.pop(context, {"isSuccess": true});
                                  // Get.back(result: {"isSuccess":true});
                                  // Navigator.pop(context, "data");
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
    // var selectType = userData?.wings
    //     .where((element) => element.vWingName == data?.wings)
    //     .toList();
    // if (selectType!.isNotEmpty) {
    //   value = selectType[0];
    // }
    propertyNameController.text = data?.vPropertyName ?? "";
  }
}
