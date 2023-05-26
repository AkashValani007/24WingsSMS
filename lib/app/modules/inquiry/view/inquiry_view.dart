import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../generated/locales.g.dart';
import '../../../../util/connectivity_utils.dart';
import '../../../constant/LocalColors.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../routes/app_pages.dart';
import '../model/constant_city_model.dart';
import '../viewmodel/constantcity_viewmodel.dart';
import '../viewmodel/inquiry_viewmodel.dart';
import 'package:after_layout/after_layout.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with AfterLayoutMixin<RegisterView> {

  late InquiryViewModel _serviceInquiry;
  late ConstantCityViewModel _serviceCity;


  // Retrofit
  List<ConstantCityData>? state = [];
  ConstantCityData? sta;

  ConstantDisData? dist;
  List<ConstantCityResponse>? cityResponse = [];

  //ConstantCityData? constant;
  ConstantCityResponse? constantT;
  String? stateSelect;
  String? citySelect;

  var mobileNumberController = TextEditingController();
  var userNameController = TextEditingController();
  var societyNameController = TextEditingController();
  var societyAddressController = TextEditingController();
  var pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode  _statedroupfocusnode = FocusNode();
  final FocusNode  _citydroupfocusnode = FocusNode();

  final FocusNode  _mobilenumberfocusnode = FocusNode();
  final FocusNode  _usernamefocusnode = FocusNode();
  final FocusNode  _societynamefocusnode = FocusNode();
  final FocusNode  _societyaddressfocusnode = FocusNode();
  final FocusNode  _pincodefocusnode = FocusNode();

  @override
  void afterFirstLayout(BuildContext context) {
    _serviceInquiry = InquiryViewModel(context);
    _serviceCity = ConstantCityViewModel(context);
    getDisData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        title: Text(
          LocaleKeys.registerInquiry.tr,
          style: TextStyle(
            color: whiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.h),
              CustomTextInput(
                title: LocaleKeys.phoneNumber.tr,
                textEditController: mobileNumberController,
                inputType: InputType.vMobileName,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _mobilenumberfocusnode,
                maxLength: 10,
                hintText: LocaleKeys.phoneNumberHint.tr,
                validator: (_) {
                  return;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextInput(
                title: LocaleKeys.userName.tr,
                textEditController: userNameController,
                inputType: InputType.vUserName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                focusNode: _usernamefocusnode,
                maxLength: 50,
                hintText: LocaleKeys.userNameHint.tr,
                validator: (_) {
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextInput(
                title: LocaleKeys.societyName.tr,
                textEditController: societyNameController,
                inputType: InputType.vSocietyName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                focusNode: _societynamefocusnode,
                maxLength: 50,
                hintText: LocaleKeys.societyNameHint.tr,
                validator: (_) {
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextInput(
                title: LocaleKeys.societyAddress.tr,
                textEditController: societyAddressController,
                inputType: InputType.vSocietyAddress,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                focusNode: _societyaddressfocusnode,
                maxLength: 50,
                hintText: LocaleKeys.societyAddressHint.tr,
                validator: (_) {
                  return null;
                },
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
                            LocaleKeys.state.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          // constant == null
                          //     ? Container()
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: whiteColor,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<ConstantCityData>(
                                  focusNode: _statedroupfocusnode,
                                  hint: Text(LocaleKeys.selectStateHint.tr,style: TextStyle(color: hintColor)),
                                  value: sta,
                                  items: state?.map((ConstantCityData value) {
                                    return DropdownMenuItem<ConstantCityData>(
                                      value: value,
                                      child: Text(value.vStateName.toString()),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (values) {
                                    setState(() {
                                      sta = values;
                                    });
                                  },
                                ),
                              ),
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
                            LocaleKeys.cityV.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          // disList.isEmpty
                          //     ? Container()
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: whiteColor,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<ConstantDisData>(
                                  focusNode: _citydroupfocusnode,
                                  hint: Text(LocaleKeys.selectCityHint.tr,style: TextStyle(color: hintColor)),
                                  value: dist,
                                  items: sta?.listDistrict
                                      ?.map((ConstantDisData value) {
                                    return DropdownMenuItem<ConstantDisData>(
                                      value: value,
                                      child: Text(value.vDistrictName.toString()),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (values) {
                                    setState(() {
                                      dist = values;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextInput(
                title: LocaleKeys.pincode.tr,
                textEditController: pincodeController,
                inputType: InputType.vPincodeName,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                focusNode: _pincodefocusnode,
                maxLength: 6,
                hintText: LocaleKeys.pincodeHint.tr,
                validator: (_) {
                  return null;
                },
              ),
              SizedBox(height: 23.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        var mobileNumber = mobileNumberController.text;
                        var userName = userNameController.text;
                        var societyName = societyNameController.text;
                        var vSocietyAddress = societyAddressController.text;
                        var pincode = pincodeController.text;
                        stateSelect = sta?.vStateName.toString();
                        citySelect = dist?.vDistrictName.toString();

                        if (mobileNumber.isEmpty) {
                          flutterToastBottom(LocaleKeys.phoneNumberHint.tr);
                        }
                        else if (mobileNumber.length != 10){
                          flutterToastBottom(LocaleKeys.mobileNumberErrorMessage.tr);
                        }
                        else if (userName.isEmpty) {
                          flutterToastBottom(LocaleKeys.userNameHint.tr);
                        }
                        else if (societyName.isEmpty) {
                          flutterToastBottom(LocaleKeys.societyNameHint.tr);
                        }
                        else if (vSocietyAddress.isEmpty) {
                          flutterToastBottom(LocaleKeys.societyAddressHint.tr);
                        }
                        else if (pincode.isEmpty) {

                          flutterToastBottom(LocaleKeys.pincodeHint.tr);
                        }
                        else if (pincode.length != 6){
                          flutterToastBottom(LocaleKeys.digitPincodeErrorMessage.tr);
                        }
                        else if (stateSelect == null){
                          flutterToastBottom(LocaleKeys.selectStateErrorMessage.tr);
                        }
                        else if (citySelect == null){
                          flutterToastBottom(LocaleKeys.selectCityErrorMessage.tr);
                        }

                        if (ConnectivityUtils.instance.hasInternet) {
                          // stateSelect = sta?.vStateName.toString();
                          // citySelect = dist?.vDistrictName.toString();

                          if (mobileNumber.isNotEmpty && userName.isNotEmpty && societyName.isNotEmpty
                              && vSocietyAddress.isNotEmpty && pincode.isNotEmpty && pincode.length == 6 && stateSelect!.isNotEmpty && citySelect!.isNotEmpty) {
                            var inquiryData = await _serviceInquiry.inquiry(
                                userName,
                                societyName,
                                vSocietyAddress,
                                "",
                                "",
                                pincode,
                                mobileNumber);
                            if (inquiryData?.isSuccess ?? false) {
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool("isLogin", true);

                              showExitPopup();
                              /*Fluttertoast.showToast(
                                msg: constantT!.vMessage.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);*/
                            }

                          }
                        }
                        else {
                          flutterToastBottom(
                              LocaleKeys.internetMsg.tr);
                        }
                      },
                      child: Container(
                        height: 40.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text(
                            LocaleKeys.submit.tr,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }

  showExitPopup() async {
    return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text(LocaleKeys.submitFinalMessage.tr),
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(13))),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 4,
                      minWidth: 80,
                      height: 33,
                      textColor: Colors.white,
                      color: Colors.black,
                      onPressed: () => Get.toNamed(Routes.LOGIN),
                      child: Text(LocaleKeys.oK.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void getDisData() async {
    var constantData = await _serviceCity.constantCity();
    if (constantData?.isSuccess ?? false) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("constantData", jsonEncode(constantData?.data));
      setState(() {
        state = constantData?.data??[];
      });
    }
  }

}
