import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_model.dart';
import 'package:maintaince/app/modules/Hallbooking/viewmodel/booking_viewmodel.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget/custom_button.dart';
import '../../addbookableproperty/model/bookable_property_model.dart';
import '../../home/model/constant_model.dart';

class BookingCreateView extends StatefulWidget {
  const BookingCreateView({Key? key}) : super(key: key);

  @override
  _BookingCreateViewState createState() => _BookingCreateViewState();
}

class _BookingCreateViewState extends State<BookingCreateView> {
  dynamic arguments = Get.arguments;

  late BookableProperty bookableProperty;
  List<BookableProperty> listBookableProperty = [];
  ConstantData? constant;

  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  List<User> userList = [];
  User? selectUser;

  var bookingDateController = TextEditingController();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var altMobileController = TextEditingController();
  var addressController = TextEditingController();
  var rentController = TextEditingController();
  var advanceController = TextEditingController();

  BookingType? selectBookingType;
  bool isEdit = false;
  int isOwner = 1;

  HallBooking? booking;

  late BookingViewModel _service;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  String dateTime = "";

  var languageS = PreferenceManager.getString("vLanguage");

  @override
  void initState() {
    super.initState();
    _service = BookingViewModel(context);
    if (arguments != null) {
      // isEdit = arguments['isEdit'];
      // booking = argumentsts['Booking'];
      bookableProperty = arguments['propertyData'];
      listBookableProperty = arguments['listBookableProperty'];
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
          isEdit ? LocaleKeys.editBooking.tr : LocaleKeys.addBookingV.tr,
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
                              LocaleKeys.selectAmenities.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            listBookableProperty.isEmpty
                                ? Container()
                                : DropdownButton<BookableProperty>(
                                    hint: Text(LocaleKeys.selectWing.tr),
                                    value: bookableProperty,
                                    items: listBookableProperty
                                        .map((BookableProperty value) {
                                      return DropdownMenuItem<BookableProperty>(
                                        value: value,
                                        child: Text(
                                          value.vPropertyName!,
                                          style: TextStyle(color: blackColor),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        bookableProperty = value!;
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
                              LocaleKeys.bookingDate.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: bookingDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.selectBookingDate.tr,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    // DatePicker.showDatePicker(context,
                                    //     showTitleActions: true,
                                    //     minTime: DateTime(DateTime.now().year),
                                    //     maxTime:
                                    //         DateTime(DateTime.now().year + 2),
                                    //     onChanged: (date) {
                                    //   print('change $date');
                                    // }, onConfirm: (date) {
                                    //   // selectedStartDate = date;
                                    //   // setState(() {
                                    //   //   startDate.text =
                                    //   //       DateFormat("yyyy-MM-dd")
                                    //   //           .format(date);
                                    //   // });
                                    // },
                                    //     currentTime: DateTime.now(),
                                    //     locale: LocaleType.en);
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        //get today's date
                                        firstDate: DateTime.now(),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));
                                    pickedDate.isNull
                                        ? "Select Booking Date"
                                        : bookingDateController.text =
                                            "${pickedDate?.year}/${pickedDate?.month}/${pickedDate?.day}";
                                  },
                                  child: Image.asset(
                                    LocaleKeys.ic_calendar,
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
                              LocaleKeys.bookingType.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            constant == null
                                ? Container()
                                : DropdownButton<BookingType>(
                                    hint: Text(
                                        LocaleKeys.selectBookingTypeHint.tr),
                                    value: selectBookingType,
                                    items: constant!.tblBookingType
                                        ?.map((BookingType value) {
                                      return DropdownMenuItem<BookingType>(
                                        value: value,
                                        child: languageS == "gu"
                                            ? Text(value.vBookingType_gj ?? "")
                                            : languageS == "hi"
                                                ? Text(
                                                    value.vBookingType_hi ?? "")
                                                : Text(
                                                    value.vBookingType ?? ""),

                                        //Text(value.vBookingType ?? ""),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (values) {
                                      setState(() {
                                        selectBookingType = values;
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
                              LocaleKeys.isOwner.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Row(
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
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOwner == 1 && wingList.length != 1,
                  child: SizedBox(
                    height: 10.h,
                  ),
                ),
                Visibility(
                  visible: isOwner == 1 && wingList.length != 1,
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
                                          getUser();
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
                Visibility(
                  visible: isOwner == 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.w, right: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.selectHouseNo.tr,
                                style: TextStyle(
                                    fontSize: 16.sp, color: grayTextColor),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              userList.isEmpty
                                  ? Container()
                                  : DropdownButton<User>(
                                      hint: Text(LocaleKeys.selectUserHint.tr),
                                      value: selectUser,
                                      items: userList.map((User value) {
                                        return DropdownMenuItem<User>(
                                          value: value,
                                          child: Text(
                                              "${value.vHouseNo ?? ""} - ${value.vUserName ?? ""}"),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          selectUser = value;
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
                Visibility(
                  visible: isOwner == 0,
                  child: Container(
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
                              TextField(
                                controller: nameController,
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
                ),
                Visibility(
                  visible: isOwner == 0,
                  child: SizedBox(
                    height: 20.h,
                  ),
                ),
                Visibility(
                  visible: isOwner == 0,
                  child: Container(
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
                              TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                maxLength: 10,
                                decoration: InputDecoration(
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
                              LocaleKeys.alternativeMobile.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: altMobileController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.alternativeMobileHint.tr,
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOwner == 0,
                  child: SizedBox(
                    height: 14.h,
                  ),
                ),
                Visibility(
                  visible: isOwner == 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.w, right: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.address.tr,
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
                                  hintText: LocaleKeys.addressHint.tr,
                                  isDense: true,
                                ),
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
                              LocaleKeys.rent.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: rentController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.totalAmountHint.tr,
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
                              LocaleKeys.advance.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: advanceController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.advanceAmountHint.tr,
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
                            var bookingPropertyId =
                                bookableProperty.iSBookablePropertyId;
                            var bookingDate = bookingDateController.text;
                            var name = nameController.text;
                            var mobileNumber = mobileController.text;
                            var altMobileNumber = altMobileController.text;
                            var address = addressController.text;
                            var rent = rentController.text;
                            var advance = advanceController.text;
                            var bookingTypes =
                                selectBookingType?.iBookingTypeId;
                            int? iUserId = 0;
                            if (isOwner == 1) {
                              iUserId = selectUser!.iUserId!;
                              name = "";
                              mobileNumber = "";
                              address = wing!.vSocietyAddress!;
                            } else {
                              if (name.isEmpty) {
                                return;
                              }
                              if (mobileNumber.isEmpty) {
                                return;
                              }
                              if (address.isEmpty) {
                                return;
                              }
                            }
                            // if (altMobileNumber.isEmpty) {
                            //   return;
                            // }
                            if (altMobileNumber.isNotEmpty && altMobileNumber.length != 10) {
                              return;
                            }
                            // if (rent.isEmpty) {
                            //   return;
                            // }
                            //
                            // if (advance.isEmpty) {
                            //   return;
                            // }

                            if (ConnectivityUtils.instance.hasInternet) {
                              if (isEdit) {
                                // var createData = await _service.updateBooking(
                                //     name,
                                //     booking?.iBookingId ?? 0,
                                //     mobileNumber,
                                //     flat?.iHouseId ?? 0,
                                //     email,
                                //     bName,
                                //     bAddress,
                                //     BookingTypes!);
                                // if (createData?.isSuccess ?? false) {
                                //   Get.back(result: createData?.data);
                                // }
                                // Fluttertoast.showToast(
                                //     msg: createData?.vMessage ?? "",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.BOTTOM,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: Colors.green,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                              } else {
                                var createData = await _service.createBooking(
                                    bookingPropertyId.toString(),
                                    bookingDate,
                                    iUserId,
                                    name,
                                    mobileNumber,
                                    altMobileNumber,
                                    address,
                                    bookingTypes!,
                                    advance,
                                    rent);
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
                          //       isEdit ? LocaleKeys.update.tr :  LocaleKeys.save.tr,
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
    getUser();
  }

  void getUser() async {
    if (ConnectivityUtils.instance.hasInternet) {
      final prefs = await SharedPreferences.getInstance();
      var database = await databaseInitialise();
      var tempList =
          await database.userDao.findWingAllUsers(wing!.iSocietyWingId!);
      setState(() {
        userList = tempList;
      });
      var userData = await _service.getUser(wing!.iSocietyWingId!);
      if (userData?.isSuccess ?? false) {
        prefs.setInt("user_timestamp_${wing!.iSocietyWingId!}",
            DateTime.now().millisecondsSinceEpoch);
        setState(() {
          userList.addAll(userData?.data ?? []);
        });
        if (userData?.data != null && userData!.data!.isNotEmpty) {
          database.userDao.insertUserMultiple(userData.data!);
        }
      } else {
        flutterToastBottom(LocaleKeys.internetMsg);
      }
    }
  }

  void getConstantData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      constant = ConstantData.fromJson(
          jsonDecode(prefs.getString("constantData") ?? ""));
    });
  }
}
