import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../generated/locales.g.dart';
import '../../../../util/connectivity_utils.dart';
import '../../../constant/LocalColors.dart';
import '../../../widget/custom_button.dart';
import '../../login/model/login_model.dart';
import '../../user/viewmodel/user_viewmodel.dart';
import '../model/constant_model.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  var nameController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var emailController = TextEditingController();
  var businessNameController = TextEditingController();
  var businessAddressController = TextEditingController();
  var dateofbirthController = TextEditingController();

  int isGender = 1;

  DateTime? selectedBirthDate;
  DateTime currentDate = DateTime.now();
  HouseData? flat;
  UserTypeData? selectUserType;

  late SharedPreferences prefs;
  late UserViewModel _service;

  UserData? userData;
  bool isNewData = true;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _service = UserViewModel(context);
    getUserData();
    getGender();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBackground,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(LocaleKeys.editProfile.tr,
            style: TextStyle(color: blackColor)),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: blackColor, //change your color here
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.name.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.nameHint.tr,
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
                            LocaleKeys.mobileNumber.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: mobileNumberController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              counterText: "",
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.mobileNumberHint.tr,
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
                            LocaleKeys.email.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
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
              SizedBox(height: 25.h),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.gender.tr,
                      style: TextStyle(fontSize: 16.sp, color: grayTextColor),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: RadioListTile(
                            title: Text(LocaleKeys.male.tr),
                            value: 1,
                            groupValue: isGender,
                            onChanged: (value) {
                              setState(() {
                                isGender = value!;
                              });
                            },
                          ),
                        ),
                        //SizedBox(width: 5.h),
                        Flexible(
                          flex: 2,
                          child: RadioListTile(
                            title: Text(LocaleKeys.female.tr),
                            value: 0,
                            groupValue: isGender,
                            onChanged: (value) {
                              setState(() {
                                isGender = value!;
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
              SizedBox(height: 15.h),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.dateOfBirth.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: dateofbirthController,
                            onTap: () async {
                              await showDatePicker(
                                  context: context,
                                  // selectableDayPredicate: _predicate,
                                  initialDate: DateTime(2010),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2010),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.black,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  }).then((selectedDate) {
                                if (selectedDate != null) {
                                  dateofbirthController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.selectDOBHint.tr,
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
                            LocaleKeys.businessName.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: businessNameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
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
                          TextField(
                            controller: businessAddressController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
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
              SizedBox(height: 25.h),
              GestureDetector(
                  onTap: () async {
                    var name = nameController.text;
                    var mobileNumber = mobileNumberController.text;
                    var email = emailController.text;
                    var businessName = businessNameController.text;
                    var businessAddress = businessAddressController.text;
                    var dtDOB = dateofbirthController.text;

                    if (name.isEmpty) {
                      flutterToastBottom(LocaleKeys.errorNameMessage.tr);
                    } else if (email.isEmpty) {
                      flutterToastBottom(LocaleKeys.errorEmailMessage.tr);
                    } else if (dtDOB.isEmpty) {
                      flutterToastBottom(LocaleKeys.errorDateOfBirthMessage.tr);
                    } else if (ConnectivityUtils.instance.hasInternet) {
                      var editData = await _service.editUser(
                          userData?.iUserId ?? 0,
                          name,
                          email,
                          isGender,
                          businessName,
                          businessAddress,
                          dtDOB);
                      if (editData?.isSuccess ?? false) {
                        userData?.vUserName = name;
                        userData?.vEmail = email;
                        userData?.vBusinessName = businessName;
                        userData?.vBusinessAddress = businessAddress;
                        userData?.dtDOB = dtDOB;
                        prefs.setString("userData", jsonEncode(userData));

                        prefs.setInt("isGender", isGender);

                        Get.back(result: true);
                      }
                      flutterToastBottomGreen(
                          editData?.vMessage ?? "");
                    } else {
                      flutterToastBottom(LocaleKeys.internetMsg);
                    }
                  },
                  child: CustomButton(
                    height: 39.h,
                    width: Get.width,
                    text: LocaleKeys.save.tr,
                    margin: EdgeInsets.only(left: 16.w, right: 16.w),
                    variant: ButtonVariant.OutlinePink8004c,
                    padding: ButtonPadding.PaddingAll10,
                    fontStyle: ButtonFontStyle.RobotoRomanSemiBold18,
                    alignment: Alignment.bottomCenter,
                  )
                  // child: Container(
                  //   margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           height: 40.h,
                  //           margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //           decoration: BoxDecoration(
                  //               color: blackColor,
                  //               borderRadius:
                  //               const BorderRadius.all(Radius.circular(10))),
                  //           child: Center(
                  //             child: Text(
                  //               LocaleKeys.save.tr,
                  //               style: TextStyle(
                  //                 color: whiteColor,
                  //                 fontSize: 16.sp,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }

  void getUserData() async {
    prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    nameController.text = userData?.vUserName ?? "";
    mobileNumberController.text = userData?.vMobile ?? "";
    emailController.text = userData?.vEmail ?? "";
    dateofbirthController.text = userData?.dtDOB ?? "";
    businessNameController.text = userData?.vBusinessName ?? "";
    businessAddressController.text = userData?.vBusinessAddress ?? "";


  }

  void getGender() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGender = prefs.getInt("isGender") ?? 1;
    });
  }
}
