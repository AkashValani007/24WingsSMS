import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/home/model/constant_model.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';
import 'package:maintaince/app/modules/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/app/widget/preference_manager.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_button.dart';
import '../../user/model/user_model.dart';

class TransactionCreateView extends StatefulWidget {
  const TransactionCreateView({Key? key}) : super(key: key);

  @override
  _TransactionCreateViewState createState() => _TransactionCreateViewState();
}

class _TransactionCreateViewState extends State<TransactionCreateView> {
  List<String> amountType = ["Credit", "Debit"];
  List<String> transactionType = [];
  List<String> transactionDetails = [];

  List<String> months = [
    LocaleKeys.one.tr,
    LocaleKeys.two.tr,
    LocaleKeys.three.tr,
    LocaleKeys.four.tr,
    LocaleKeys.five.tr,
    LocaleKeys.six.tr,
    LocaleKeys.seven.tr,
    LocaleKeys.eight.tr,
    LocaleKeys.nine.tr,
    LocaleKeys.ten.tr,
    LocaleKeys.eleven.tr,
    LocaleKeys.twelve.tr
  ];
  List<WatchmenData> watchmenList = [];

  List<User> userList = [];

  UserData? userData;
  List<WingData> wingList = [];
  WingData? wing;

  ConstantData? constant;
  String? selectTransactionType;
  String? selectTransactionDetails;
  String? selectMonth = LocaleKeys.one.tr;
  User? selectUser;
  WatchmenData? watchment;
  String? selectAmountType = "Credit";

  late TransactionViewModel _service;

  var transactionNumberController = TextEditingController();
  var paymentDescriptionController = TextEditingController();
  var amountController = TextEditingController();
  DateTime? selectedPaymentDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  var paymentDate = TextEditingController();
  var startDate = TextEditingController();
  var endDate = TextEditingController();

  var languageS = PreferenceManager.getString("vLanguage");

  @override
  void initState() {
    super.initState();
    _service = TransactionViewModel(context);
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
          LocaleKeys.addTransaction.tr,
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
                                  hint: Text(
                                    LocaleKeys.selectWing.tr,
                                  ),
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
                            LocaleKeys.amountType.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          DropdownButton<String>(
                            hint: Text(LocaleKeys.selectAmountTypeHint.tr),
                            value: selectAmountType,
                            items: amountType.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                selectAmountType = value;
                                if (value == "Credit") {
                                  selectTransactionDetails = null;
                                  print(
                                      "=================CREDIT=================");
                                  transactionDetails =
                                      constant?.creditType ?? [];
                                } else {
                                  selectTransactionDetails = null;
                                  print(
                                      "=================DEBIT=================");
                                  transactionDetails =
                                      constant?.debitType ?? [];
                                }
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
                            LocaleKeys.transactionType.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          //transactionTypeGj.isEmpty
                          //? Container()
                          //:
                          DropdownButton<String>(
                            hint: Text(LocaleKeys.selectTransactionTypeHint.tr),
                            value: selectTransactionType,
                            items: transactionType.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                selectTransactionType = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectTransactionType != null &&
                    selectTransactionType != "Cash",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionType != null &&
                    selectTransactionType != "Cash",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.transactionNumber.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: transactionNumberController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.transactionNumberHint.tr,
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
                            LocaleKeys.paymentType.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          //transactionDetails.isEmpty
                          //? Container()
                          DropdownButton<String>(
                            hint: Text(LocaleKeys.selectPaymentTypeHint.tr),
                            value: selectTransactionDetails,
                            items: transactionDetails.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                selectTransactionDetails = value ?? "";
                                if (selectTransactionDetails == "Maintenance") {
                                  if (userList.isEmpty) {
                                    getUser();
                                  }
                                } else if (selectTransactionDetails ==
                                    "Watchment Payment") {
                                  if (userList.isEmpty) {
                                    getWatchmen();
                                  }
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Maintenance",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Maintenance",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.user.tr,
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
                visible: selectTransactionDetails == "Watchment Payment",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Watchment Payment",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.watchman.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            watchmenList.isEmpty
                                ? Container()
                                : DropdownButton<WatchmenData>(
                                    hint: Text(LocaleKeys.selectWatchmen.tr),
                                    value: watchment,
                                    items:
                                        watchmenList.map((WatchmenData value) {
                                      return DropdownMenuItem<WatchmenData>(
                                        value: value,
                                        child: Text(value.vWatchmenName ?? ""),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        watchment = value;
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
                visible: selectTransactionDetails == "Maintenance",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Maintenance",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.noOfMonths.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            DropdownButton<String>(
                              hint: Text(LocaleKeys.selectNoOfMonthsHint.tr),
                              value: selectMonth,
                              items: months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  selectMonth = value ?? "";
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
                visible: selectTransactionDetails == "Other",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Other",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.paymentDescription.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: paymentDescriptionController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.paymentDescriptionHint.tr,
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
                visible: selectTransactionDetails == "Maintenance",
                child: SizedBox(
                  height: 14.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails == "Maintenance",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectMonth != null && selectMonth! != "1"
                                  ? LocaleKeys.startMonth.tr
                                  : LocaleKeys.endMonth.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              controller: startDate,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.selectStartMonthHint.tr,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 4),
                                        lastDate: selectedEndDate != null
                                            ? DateTime(selectedEndDate!.year,
                                                selectedEndDate!.month - 1)
                                            : DateTime(DateTime.now().year + 4),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Colors.black,
                                                onPrimary: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        }).then((selectedDate) {
                                      if (selectedDate != null) {
                                        selectedStartDate = selectedDate;
                                        startDate.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                      }
                                    });
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
                      Visibility(
                        visible: selectMonth != null && selectMonth! != "1",
                        child: SizedBox(
                          width: 10.h,
                        ),
                      ),
                      Visibility(
                        visible: selectMonth != null && selectMonth! != "1",
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.endMonth.tr,
                                style: TextStyle(
                                    fontSize: 16.sp, color: grayTextColor),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              TextField(
                                controller: endDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: hintColor),
                                  hintText: LocaleKeys.selectEndMonthHint.tr,
                                  isDense: true,
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      if (startDate.text.isNotEmpty) {
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: selectedStartDate != null
                                                ? DateTime(
                                                    selectedStartDate?.year ??
                                                        0,
                                                    selectedStartDate?.month ??
                                                        0 + 1)
                                                : DateTime(
                                                    DateTime.now().year - 4),
                                            lastDate: DateTime(
                                                DateTime.now().year + 4),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: Colors.black,
                                                    onPrimary: Colors.white,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            }).then((selectedDate) {
                                          if (selectedDate != null) {
                                            selectedEndDate = selectedDate;
                                            endDate.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(selectedDate);
                                          }
                                        });
                                      } else {
                                        flutterToastBottom(LocaleKeys
                                            .selectStartDateMessage.tr);
                                      }
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
                            selectTransactionDetails == "Maintenance"
                                ? LocaleKeys.amountPerMonth.tr
                                : LocaleKeys.amount.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: grayTextColor),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: LocaleKeys.enterAmountHint.tr,
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
                visible: selectTransactionDetails != "Maintenance",
                child: SizedBox(
                  height: 20.h,
                ),
              ),
              Visibility(
                visible: selectTransactionDetails != "Maintenance",
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.paymentDate.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, color: grayTextColor),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            TextField(
                              readOnly: true,
                              controller: paymentDate,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: hintColor),
                                hintText: LocaleKeys.paymentDateHint.tr,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime:
                                            DateTime(DateTime.now().year - 2),
                                        maxTime:
                                            DateTime(DateTime.now().year + 2),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      selectedPaymentDate = date;
                                      setState(() {
                                        paymentDate.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(date);
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
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
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        var lAmountType =
                            selectAmountType == LocaleKeys.credit.tr ? 0 : 1;
                        var lTransactionType = selectTransactionType;
                        var lTransactionNumber =
                            transactionNumberController.text;
                        var lPaymentDetail = selectTransactionDetails;
                        /*if (lPaymentDetail == "Other") {
                          lPaymentDetail = paymentDescriptionController.text;
                        }*/
                        var lUserId = selectUser?.iUserId ?? 0;
                        var lWatchmenId = watchment?.iWatchmenId ?? 0;
                        var lMonths = selectMonth;
                        var lStartDt = startDate.text;
                        var lEndDt = endDate.text;
                        var lPaymentDt = paymentDate.text;
                        var lAmount = amountController.text;
                        var startDateTime = selectedStartDate;
                        if (ConnectivityUtils.instance.hasInternet) {
                          if (lPaymentDetail != "Maintenance") {
                            if (lTransactionType == null) {
                              flutterToastBottom(
                                  LocaleKeys.transactionTypeErrorMessage.tr);
                              return;
                            }
                            if (lPaymentDetail == null) {
                              flutterToastBottom(
                                  LocaleKeys.paymentDetailErrorMessage.tr);
                              return;
                            } else if (lPaymentDetail == "Watchment Payment") {
                              if (watchment == null) {
                                flutterToastBottom(
                                    LocaleKeys.selectWatchmen.tr);
                                return;
                              }
                            } else if (lPaymentDetail == "Other") {
                              var paymentSubDet =
                                  paymentDescriptionController.text;
                              if (paymentSubDet.isEmpty) {
                                flutterToastBottom(LocaleKeys
                                    .paymentDescriptionErrorMessage.tr);
                                return;
                              }
                              lPaymentDetail = paymentSubDet;
                            }
                            if (lAmount.isEmpty) {
                              flutterToastBottom(
                                  LocaleKeys.enterAmountErrorMessage.tr);
                              return;
                            }
                            if (paymentDate.text.isEmpty) {
                              flutterToastBottom(
                                  LocaleKeys.paymentDateErrorMessage.tr);
                              return;
                            }
                            if (wing!.iSocietyWingId == null ||
                                wing!.iSocietyWingId == 0) {
                              flutterToastBottom(
                                  LocaleKeys.invalidWingErrorMessage.tr);
                              return;
                            }
                            var createData = await _service.createTransaction(
                                wing!.iSocietyWingId!,
                                lUserId,
                                lAmountType,
                                lTransactionType ?? "",
                                int.parse(lAmount),
                                lPaymentDt,
                                lTransactionNumber,
                                lPaymentDetail ?? "");
                            if (createData?.isSuccess ?? false) {
                              Get.back(result: createData?.data);
                            }
                            flutterToastBottomGreen(createData?.vMessage ?? "");
                          } else {
                            if (lTransactionType == null) {
                              flutterToastBottom(
                                  LocaleKeys.transactionTypeErrorMessage.tr);
                              return;
                            }
                            if (lPaymentDetail == null) {
                              flutterToastBottom(
                                  LocaleKeys.paymentDateErrorMessage.tr);
                              return;
                            }
                            if (selectUser == null) {
                              flutterToastBottom(
                                  LocaleKeys.selectUserErrorMessage.tr);
                              return;
                            }
                            if (lMonths == "1") {
                              if (startDate.text.isEmpty) {
                                flutterToastBottom(
                                    LocaleKeys.maintenanceDateErrorMessage.tr);
                                return;
                              }
                              if (lAmount.isEmpty) {
                                flutterToastBottom(
                                    LocaleKeys.enterAmountErrorMessage.tr);
                                return;
                              }
                              startDateTime = DateTime(
                                  startDateTime!.year, startDateTime.month, 1);
                              lStartDt = DateFormat("yyyy-MM-dd")
                                  .format(startDateTime);
                              var createData = await _service.createTransaction(
                                  wing!.iSocietyWingId!,
                                  lUserId,
                                  lAmountType,
                                  lTransactionType ?? "",
                                  int.parse(lAmount),
                                  lStartDt,
                                  lTransactionNumber,
                                  lPaymentDetail ?? "");
                              if (createData?.isSuccess ?? false) {
                                Get.back(result: createData?.data);
                              }
                              flutterToastBottomGreen(
                                  createData?.vMessage ?? "");
                            } else {
                              if (startDate.text.isEmpty) {
                                flutterToastBottom(
                                    LocaleKeys.selectStartDateMessage.tr);
                                return;
                              }
                              if (endDate.text.isEmpty) {
                                flutterToastBottom(
                                    LocaleKeys.endDateErrorMessage.tr);
                                return;
                              }
                              if (lAmount.isEmpty) {
                                flutterToastBottom(
                                    LocaleKeys.enterAmountErrorMessage.tr);
                                return;
                              }

                              List<TransactionData> tempList = [];
                              startDateTime = DateTime(
                                  startDateTime!.year, startDateTime.month, 1);
                              lStartDt = DateFormat("yyyy-MM-dd")
                                  .format(startDateTime);
                              for (var i = 0; i < int.parse(lMonths!); i++) {
                                var createData =
                                    await _service.createTransaction(
                                        wing!.iSocietyWingId!,
                                        lUserId,
                                        lAmountType,
                                        lTransactionType ?? "",
                                        int.parse(lAmount),
                                        lStartDt,
                                        lTransactionNumber,
                                        lPaymentDetail ?? "");
                                startDateTime = DateTime(startDateTime!.year,
                                    startDateTime.month + 1, 1);
                                lStartDt = DateFormat("yyyy-MM-dd")
                                    .format(startDateTime);
                                if (createData?.isSuccess ?? false) {
                                  tempList.add(createData!.data!);
                                }
                                if (i == int.parse(lMonths) - 1) {
                                  flutterToastBottomGreen(
                                      createData?.vMessage ?? "");
                                  Get.back(result: tempList);
                                }
                              }
                            }
                          }
                        } else {
                          flutterToastBottom(LocaleKeys.internetMsg.tr);
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
                      ),
                      // child: Container(
                      //   height: 40.h,
                      //   margin: EdgeInsets.symmetric(horizontal: 16.w),
                      //   decoration: BoxDecoration(
                      //       color: blackColor,
                      //       borderRadius:
                      //       const BorderRadius.all(Radius.circular(10))),
                      //   child: Center(
                      //     child: Text(
                      //       LocaleKeys.save.tr,
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

  void getWatchmen() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var constantData = await _service.getWatchmen();
      if (constantData?.isSuccess ?? false) {
        setState(() {
          watchmenList = constantData?.data ?? [];
        });
      } else {
        flutterToastBottom(LocaleKeys.internetMsg.tr);
      }
    }
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
        flutterToastBottom(LocaleKeys.internetMsg.tr);
      }
    }
  }

  void getUserData() async {
    //final prefs = await SharedPreferences.getInstance();
    PreferenceManager.getInstance();
    userData = UserData.fromJson(
        jsonDecode(PreferenceManager.getString("userData") ?? ""));

    wingList = userData!.wings;
    wing = wingList[0];
    // getUser();
  }

  Future<void> getConstantData() async {
    //final prefs = await SharedPreferences.getInstance();
    PreferenceManager.getInstance();
    setState(() {
      constant = ConstantData.fromJson(
          jsonDecode(PreferenceManager.getString("constantData") ?? ""));
      transactionType = constant?.amountType ?? [];
      transactionDetails = constant?.creditType ?? [];
    });
  }
}
