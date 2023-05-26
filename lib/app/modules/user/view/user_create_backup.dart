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
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_form_field1.dart';
import '../../home/model/constant_model.dart';
import '../model/user_model.dart';

class UserCreateView extends StatefulWidget {
  const UserCreateView({Key? key}) : super(key: key);

  @override
  _UserCreateViewState createState() => _UserCreateViewState();
}

class _UserCreateViewState extends State<UserCreateView> {
  List<HouseData> flatList = [];

  List<WingData> wingList = [];
  WingData? wing;

  ConstantData? constant;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bNameController = TextEditingController();
  final TextEditingController bAddressController = TextEditingController();
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
                            LocaleKeys.userType.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          constant == null
                              ? Container()
                              : DropdownButton<UserTypeData>(
                                  hint: Text(LocaleKeys.userTypeHint.tr),
                                  value: selectUserType,
                                  items: constant!.tblUserTypeMaster
                                      ?.map((UserTypeData value) {
                                    return DropdownMenuItem<UserTypeData>(
                                      value: value,
                                      child: languageS == "gu"
                                          ? Text(value.vUserTypeName_gj ?? "")
                                          : languageS == "hi"
                                              ? Text(
                                                  value.vUserTypeName_hi ?? "")
                                              : Text(value.vUserTypeName ?? ""),

                                      // Text(value.vUserTypeName ?? ""),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (values) {
                                    setState(() {
                                      selectUserType = values;
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
                child: CustomTextFormField1(
                  controller: nameController,
                  width: 345,
                  // variant: TextFormFieldVariant.UnderlineGray90005,
                  focusNode: FocusNode(),
                  hintText:  LocaleKeys.name.tr,
                  alignment: Alignment.topRight,
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 16.w, right: 16.w),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               LocaleKeys.name.tr,
              //               style: TextStyle(
              //                   fontSize: 16.sp, color: grayTextColor),
              //             ),
              //             SizedBox(
              //               height: 6.h,
              //             ),
              //             TextFormField(
              //               controller: nameController,
              //               decoration: InputDecoration(
              //                 hintStyle: TextStyle(color: hintColor),
              //                 hintText: LocaleKeys.nameHint.tr,
              //                 isDense: true,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20.h,
              ),

              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: CustomTextFormField1(
                  controller: mobileController,
                  width: 345,
                  textInputType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  // variant: TextFormFieldVariant.UnderlineGray90005,
                  focusNode: FocusNode(),
                  hintText:  LocaleKeys.phoneNumberC.tr,
                  alignment: Alignment.topRight,
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
                            LocaleKeys.phoneNumberC.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.phoneNumberHint.tr,
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
                            LocaleKeys.houseNo.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          flatList.isEmpty
                              ? Container()
                              : DropdownButton<HouseData>(
                                  hint: Text(LocaleKeys.selectHouseNo.tr),
                                  value: flat,
                                  items: flatList.map((HouseData value) {
                                    return DropdownMenuItem<HouseData>(
                                      value: value,
                                      child: Text(value.vHouseNo ?? ""),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      flat = value;
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
                            LocaleKeys.emailC.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.emailHint.tr,
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
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.businessName.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            controller: bNameController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.businessNameHint.tr,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.businessAddress.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            controller: bAddressController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.businessAddressHint.tr,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Society Wing",
                      style:
                      TextStyle(fontSize: 16.sp, color: grayTextColor),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    DropdownButton<String>(
                      hint: const Text("Select Wing"),
                      items: wingList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                      onChanged: (_) {

                      },
                    ),
                  ],
                ),
              ),*/

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
                          var email = emailController.text;
                          var bName = bNameController.text;
                          var bAddress = bAddressController.text;
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
                                  userData?.iUserId ?? 0,
                                  mobileNumber,
                                  flat?.iHouseId ?? 0,
                                  email,
                                  bName,
                                  bAddress,
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
                                email,
                                bName,
                                bAddress,
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
    // setDataTextFiled();

    // getHouseList();
  }

  void getHouseList() async {
    // flatList = wing.houseList; /// changing by hiren
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
    emailController.text = userDataNew?.vEmail ?? "";
    bNameController.text = userDataNew?.vBusinessName ?? "";
    bAddressController.text = userDataNew?.vBusinessAddress ?? "";
    mobileController.text = userDataNew?.vMobile ?? "";
    nameController.text = userDataNew?.vUserName ?? "";
  }
}
