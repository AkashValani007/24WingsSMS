import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/viewmodel/user_viewmodel.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/utils/image_constant.dart';
import '../../../constant/utils/size_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_drop_down.dart';
import '../../../widget/custom_image_view.dart';
import '../../../widget/custom_text_form_field1.dart';
import '../../home/model/constant_model.dart';
import '../model/user_model.dart';

class UserCreateView extends StatefulWidget {
  const UserCreateView({Key? key}) : super(key: key);

  @override
  _UserCreateViewState createState() => _UserCreateViewState();
}

class _UserCreateViewState extends State<UserCreateView> {
  List<String> strFlatList = [];
  List<HouseData> flatList = [];

  List<WingData> wingList = [];
  WingData? wing;

  ConstantData? constant;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController bNameController = TextEditingController();
  // final TextEditingController bAddressController = TextEditingController();
  HouseData? flat;
  dynamic arguments = Get.arguments;
  UserTypeData? selectUserType;
  bool isEdit = false;
  int isOwner = 1;
  int isCommitteeMember = 0;
  List<UserData> userList = [];
  late UserData userData;
  User? userDataNew;

  late UserViewModel _service;

  var languageS = PreferenceManager.getString("vLanguage");

  @override
  void initState() {
    super.initState();
    _service = UserViewModel(context);
    if (arguments != null) {
      //print("isEdit$arguments['isEdit']");
      // print("userData$arguments['userData']");
      isEdit = arguments['isEdit'];
      userDataNew = arguments['userData'];

      setDataTextFiled();
      // UserData user = UserData(
      //     vUserName: userDataNew?.vUserName,
      //     vMobile: userDataNew?.vMobile,
      //     iGender: userData?.iGender,
      //     vEmail: userDataNew?.vEmail,
      //     iUserId: userDataNew?.iUserId,
      //     vBusinessName: userDataNew?.vBusinessName,
      //     vBusinessAddress: userDataNew?.vBusinessAddress,
      //     dtDOB: "",
      //     token: "",
      //     wings: [],
      //     village: userDataNew?.village,
      //     iMobilePrivacy: userDataNew?.iMobilePrivacy,
      //     iAddressPrivacy: userDataNew?.iAddressPrivacy,
      //     vehicle: []);
      // userData = user;
      UserData user = UserData(
          vUserName: userDataNew?.vUserName,
          vMobile: userDataNew?.vMobile,
          iGender: userData?.iGender,
          vEmail: userDataNew?.vEmail,
          iUserId: userDataNew?.iUserId,
          vBusinessName: userDataNew?.vBusinessName,
          vBusinessAddress: userDataNew?.vBusinessAddress,
          dtDOB: "",
          token: "",
          wings: [],
          village: userDataNew?.village,
          iMobilePrivacy: userDataNew?.iMobilePrivacy,
          iAddressPrivacy: userDataNew?.iAddressPrivacy,
          vehicle: []);
      userData = user;
    }
    getConstantData();
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
          isEdit ? LocaleKeys.editMember.tr : LocaleKeys.addMember.tr,
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
                                    '${value.vSocietyName} - ${LocaleKeys.wing
                                        .tr} ${value.vWingName}',
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
                child: CustomDropDown(
                  width: Get.width,
                  focusNode: FocusNode(),
                  icon: Container(
                    margin: getMargin(
                      left: 60,
                      right: 20,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.icDownArrow,
                      color: greenBorder,
                    ),
                  ),
                  hintText: LocaleKeys.userType.tr,
                  variant: DropDownVariant.OutlineGray90005,
                  shape: DropDownShape.RoundedBorder6,
                  padding: DropDownPadding.PaddingT19,
                  fontStyle: DropDownFontStyle.RobotoRomanRegular16,
                  items: getUserType(),
                  onChanged: (value) {
                    setState(() {
                      selectUserType = constant!.tblUserTypeMaster!.firstWhere((element) =>
                      element.vUserTypeName == value || element.vUserTypeName_gj == value || element.vUserTypeName_hi == value);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: CustomTextFormField1(
                  controller: nameController,
                  width: Get.width,
                  // variant: TextFormFieldVariant.UnderlineGray90005,
                  focusNode: FocusNode(),
                  hintText: LocaleKeys.name.tr,
                  alignment: Alignment.topRight,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: CustomTextFormField1(
                  controller: mobileController,
                  width: Get.width,
                  textInputType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  // variant: TextFormFieldVariant.UnderlineGray90005,
                  focusNode: FocusNode(),
                  hintText: LocaleKeys.phoneNumberC.tr,
                  alignment: Alignment.topRight,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: CustomDropDown(
                  width: Get.width,
                  focusNode: FocusNode(),
                  icon: Container(
                    margin: getMargin(
                      left: 60,
                      right: 20,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.icDownArrow,
                      color: greenBorder,
                    ),
                  ),
                  hintText: LocaleKeys.houseNo.tr,
                  variant: DropDownVariant.OutlineGray90005,
                  shape: DropDownShape.RoundedBorder6,
                  padding: DropDownPadding.PaddingT19,
                  fontStyle: DropDownFontStyle.RobotoRomanRegular16,
                  items: strFlatList,
                  onChanged: (value) {
                    setState(() {
                      flat = flatList.firstWhere((element) =>
                      element.vHouseNo == value);
                    });
                  },
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
                            LocaleKeys.isOwner.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 2,
                                child: RadioListTile(
                                  title: Text(LocaleKeys.yes.tr),
                                  value: 1,
                                  groupValue: isOwner,
                                  onChanged: (value) {
                                    setState(() {
                                      isOwner = value!;
                                    });
                                  },
                                ),
                              ),
                              //SizedBox(width: 5.h),
                              Flexible(
                                flex: 2,
                                child: RadioListTile(
                                  title: Text(LocaleKeys.no.tr),
                                  value: 0,
                                  groupValue: isOwner,
                                  onChanged: (value) {
                                    setState(() {
                                      isOwner = value!;
                                    });
                                  },
                                ),
                              ),
                              //SizedBox(width: 5.h),
                            ],
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

                          var userTypes = selectUserType?.iUserTypeId;
                          if (name.isEmpty) {
                            return;
                          }
                          if (mobileNumber.isEmpty) {
                            return;
                          }
                          if (flat == null) {
                            return;
                          }
                          if (ConnectivityUtils.instance.hasInternet) {
                            if (isEdit) {
                              var createData = await _service.updateUser(
                                  name,
                                  userData.iUserId ?? 0,
                                  mobileNumber,
                                  flat?.iHouseId ?? 0,
                                  "",
                                  "",
                                  "",
                                  userTypes!);
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }
                              flutterToastBottom(createData?.vMessage ?? "");
                            } else {
                              var createData = await _service.createUser(
                                wing!.iSocietyWingId!,
                                userTypes ?? 0,
                                isOwner,
                                isCommitteeMember,
                                flat?.iHouseId ?? 0,
                                name,
                                mobileNumber,
                                mobileNumber,
                                "",
                                "",
                                "",
                              );
                              if (createData?.isSuccess ?? false) {
                                Get.back(
                                  result: createData?.data,
                                );
                                Get.back(
                                  result: createData?.data,
                                );
                                // selectL("gj",selectUserType?.vUserTypeName_gj ?? "");

                              }
                              flutterToastBottom(createData?.vMessage ?? "");
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
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void getConstantData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      constant = ConstantData.fromJson(
          jsonDecode(prefs.getString("constantData") ?? ""));

      constant?.tblUserTypeMaster?.removeAt(0);
      constant?.tblUserTypeMaster?.removeAt(0);
    });
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    wingList = userData.wings;
    setState(() {
      wing = wingList[0];
    });
    flatList = wing?.houseList ?? [];
    strFlatList = flatList.map((e) => e.vHouseNo!).toList();
    // setDataTextFiled();

  }

  List<String> getUserType() {
    return constant!.tblUserTypeMaster!.map((e) =>
    languageS == "gu" ? e.vUserTypeName_gj??"" : languageS == "hi" ? e
        .vUserTypeName_hi??"" : e.vUserTypeName??"").toList();
  }

  void setDataTextFiled() {
    nameController.text = userDataNew?.vUserName ?? "";
    mobileController.text = userDataNew?.vMobile ?? "";
    var houseData = flatList
        .where((element) => element.vHouseNo == wing?.vHouseNo)
        .toList();
    if (houseData.isNotEmpty) {
      flat = houseData[0];
    }
    // emailController.text = userDataNew?.vEmail ?? "";
    // bNameController.text = userDataNew?.vBusinessName ?? "";
    // bAddressController.text = userDataNew?.vBusinessAddress ?? "";
    mobileController.text = userDataNew?.vMobile ?? "";
    nameController.text = userDataNew?.vUserName ?? "";
  }
}
