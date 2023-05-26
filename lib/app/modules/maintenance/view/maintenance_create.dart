import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:maintaince/app/widget/multi_select_dialog.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/common.dart';
import '../../../constant/google_font.dart';
import '../../../widget/custom_button.dart';
import '../../transaction/model/transaction_model.dart';

class MaintenanceCreateView extends StatefulWidget {
  const MaintenanceCreateView({Key? key}) : super(key: key);

  @override
  _MaintenanceViewState createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceCreateView> {
  List<TransactionData> transactionList = [];
  List<TransactionData> tempTransactionList = [];
  List<TransactionData> selectTransactionList = [];

  List<WingData> wingList = [];
  WingData? wing;

  String selectedMonthYear = "";

  late TransactionViewModel _service;
  var monthsController = TextEditingController();

  UserData? userData;

  String vStartDate = "2022-12-01";
  DateTime? selectedMonth;
  List<String> months = [];
  List<String> selectMonths = [];

  var amountController = TextEditingController();
  var amount = "1000";
  int iType = 1; // Only Maintenance Data
  @override
  void initState() {
    super.initState();

    _service = TransactionViewModel(context);
    var pastMonths = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
    for (var i = 0; i < 15; i++) {
      months.add(DateFormat('MM-yyyy').format(pastMonths));
      pastMonths = DateTime(pastMonths.year, pastMonths.month + 1, 1);
    }

    selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // selectMonth = DateFormat('MM-yyyy').format(selectedMonth!);
    selectMonths.add(DateFormat('MM-yyyy').format(selectedMonth!));
    monthsController.text = selectMonths.join(', ');
    vStartDate = DateFormat('yyyy-MM-dd').format(selectedMonth!);

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: greyBackground,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: blackColor, //change your color here
        ),
        title: Text(
          LocaleKeys.maintenance.tr,
          style: TextStyle(color: blackColor),
        ),
        actions: [
          Visibility(
            visible: (wing!.iUserTypeId == 1 ||
                wing!.iUserTypeId == 2 ||
                wing!.iUserTypeId == 3 ||
                wing!.iUserTypeId == 4),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showAmountPopup(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  child: Text(
                    "₹$amount",
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          /*GestureDetector(
            onTap: () async {
              await showDatePicker(
                  context: context,
                  initialDate: selectedMonth!,
                  firstDate: DateTime(DateTime.now().year - 4),
                  lastDate: DateTime(DateTime.now().year + 4),
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
                  selectedMonth =
                      DateTime(selectedDate.year, selectedDate.month, 1);
                  vStartDate = DateFormat('yyyy-MM-dd').format(selectedMonth!);
                  getTransaction();
                }
              });
            },
            child: Image.asset(
              LocaleKeys.ic_calendar,
            ),
          ),*/
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Card(
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
                                              style:
                                                  TextStyle(color: blackColor),
                                            ),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            wing = value;
                                            getTransaction();
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
                    visible: (wing!.iUserTypeId == 1 ||
                        wing!.iUserTypeId == 2 ||
                        wing!.iUserTypeId == 3 ||
                        wing!.iUserTypeId == 4),
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Months",
                                  style: TextStyle(
                                      fontSize: 16.sp, color: grayTextColor),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                /*DropdownButton<String>(
                                  hint:
                                  const Text("Select Months"),
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
                                ),*/
                                TextFormField(
                                  controller: monthsController,
                                  readOnly: true,
                                  onTap: () async {
                                    final List<String>? results =
                                        await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MultiSelect(
                                          items: months,
                                          selectedItems: selectMonths,
                                          title: "Select Months",
                                        );
                                      },
                                    );
                                    if (results != null) {
                                      monthsController.text =
                                          results.join(', ');
                                    }
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintStyle: TextStyle(color: hintColor),
                                    hintText: "Select Months",
                                    isDense: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*Visibility(
                    visible: (wing!.iUserTypeId == 1 ||
                        wing!.iUserTypeId == 2 ||
                        wing!.iUserTypeId == 3 ||
                        wing!.iUserTypeId == 4),
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
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
                                  hint:
                                      Text(LocaleKeys.selectNoOfMonthsHint.tr),
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
                    visible: (wing!.iUserTypeId == 1 ||
                        wing!.iUserTypeId == 2 ||
                        wing!.iUserTypeId == 3 ||
                        wing!.iUserTypeId == 4),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 10.h, bottom: 10.h),
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
                                    hintText:
                                        LocaleKeys.selectStartMonthHint.tr,
                                    isDense: true,
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                DateTime.now().year - 4),
                                            lastDate: selectedEndDate != null
                                                ? DateTime(
                                                    selectedEndDate!.year,
                                                    selectedEndDate!.month - 1)
                                                : DateTime(
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
                                      hintText:
                                          LocaleKeys.selectEndMonthHint.tr,
                                      isDense: true,
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          if (startDate.text.isNotEmpty) {
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime(
                                                    selectedStartDate!.year,
                                                    selectedStartDate!.month +
                                                        1),
                                                firstDate: selectedStartDate !=
                                                        null
                                                    ? DateTime(
                                                        selectedStartDate!.year,
                                                        selectedStartDate!
                                                                .month +
                                                            1)
                                                    : DateTime(
                                                        DateTime.now().year -
                                                            4),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 4),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          const ColorScheme
                                                              .light(
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
                                            Fluttertoast.showToast(
                                                msg: LocaleKeys
                                                    .selectStartDateMessage.tr,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
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
                  ),*/
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: const EdgeInsets.only(left: 9, right: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(
                          transactionList.length,
                          (index) {
                            return Center(
                              child: gridHouseItem(transactionList[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: (wing!.iUserTypeId == 1 ||
                  wing!.iUserTypeId == 2 ||
                  wing!.iUserTypeId == 3 ||
                  wing!.iUserTypeId == 4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (selectMonths.isEmpty) {

                          flutterToastBottom(
                              "Please select month.");
                          return;
                        }
                        if (selectTransactionList.isEmpty) {

                          flutterToastBottom(
                              LocaleKeys.selectFlatErrorMessage.tr);
                          return;
                        }
                        var listTransaction = [];
                        for (var user in selectTransactionList) {
                          for (var month in selectMonths) {
                            var date = DateFormat("MM-yyyy").parse(month);
                            var locStartDateTime =
                                DateTime(date.year, date.month, 1);
                            var lStartDt = DateFormat("yyyy-MM-dd")
                                .format(locStartDateTime);
                            listTransaction.add({
                              'iUserId': user.iUserId ?? 0,
                              'iSocietyWingId': wing!.iSocietyWingId!,
                              'iTransactionType': 0,
                              'vPaymentType': "Cash",
                              'iAmount': int.parse(amount),
                              'dPaymentDate': lStartDt,
                              'vPaymentDetails': "",
                              'vTransactionDetails': "Maintenance",
                              'iAddId': userData?.iUserId ?? 0,
                            });
                          }
                        }
                        var addTransactions =
                            await _service.addTransactions(listTransaction);
                        if (addTransactions?.isSuccess ?? false) {
                          getTransaction();
                        }
                        setState(() {
                          selectTransactionList.clear();
                        });
                      },

                      child: CustomButton(
                        height: 39.h,
                        width: Get.width,
                        text: LocaleKeys.save.tr,
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        variant: ButtonVariant.OutlinePink8004c,
                        padding: ButtonPadding.PaddingAll10,
                        fontStyle:
                        ButtonFontStyle.RobotoRomanSemiBold18,
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
            ),
            SizedBox(
              height: 40.h,
            ),
          ]),
        ),
      ),
    );
  }

  Widget gridHouseItem(TransactionData transactionData) {
    return GestureDetector(
      onTap: () {
        if ((wing!.iUserTypeId == 1 ||
            wing!.iUserTypeId == 2 ||
            wing!.iUserTypeId == 3 ||
            wing!.iUserTypeId == 4)) {
          // if (transactionData.iTransactionId == 0) {
          if (!selectTransactionList.contains(transactionData)) {
            setState(() {
              selectTransactionList.add(transactionData);
            });
          }
          // }
        }
      },
      onLongPress: () {
        if (wing!.iUserTypeId == 1 ||
            wing!.iUserTypeId == 2 ||
            wing!.iUserTypeId == 3 ||
            wing!.iUserTypeId == 4) {
          // if (transactionData.iTransactionId == 0) {
          if (selectTransactionList.contains(transactionData)) {
            setState(() {
              selectTransactionList.remove(transactionData);
            });
          }
          /*} else {
            showCancelPopup(context, transactionData);
          }*/
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: selectTransactionList.contains(transactionData)
              ? greenBorder
              : hintColor /*transactionData.iTransactionId == 0
                  ? hintColor
                  : colorGreen*/
          ,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              transactionData.vHouseNo ?? "",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    blackColor /*transactionData.iTransactionId == 0
                    ? blackColor
                    : whiteColor*/
                ,
                fontFamily: AssetsFont.fontMedium,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Visibility(
              visible: transactionData.vUserName?.isNotEmpty ?? false,
              child: Text(
                transactionData.vUserName ?? "",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      blackColor /*transactionData.iTransactionId == 0
                      ? blackColor
                      : whiteColor*/
                  ,
                  fontFamily: AssetsFont.fontMedium,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showAmountPopup(BuildContext context) async {
    amountController.text = amount;
    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: whiteColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
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
                                LocaleKeys.addMaintenanceAmount.tr,
                                style: TextStyle(
                                    fontSize: 16.sp, color: grayTextColor),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
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
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: grayTextColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.cancelC.tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            setState(() {
                              amount = amountController.text;
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.submitC.tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool?> showCancelPopup(
      BuildContext context, TransactionData transactionData) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: whiteColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    LocaleKeys.deleteMessageMaintenance.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: grayTextColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.noC.tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            setState(() {
                              transactionData.iTransactionId = 0;
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.yesC.tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    wingList = userData!.wings;
    setState(() {
      wing = wingList[0];
    });
    getTransaction();
  }

  void getTransaction() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var transactionData = await _service.getTransaction(
          wing!.iSocietyWingId!, vStartDate, vStartDate, iType);
      if (transactionData?.isSuccess ?? false) {
        setState(() {
          transactionList = transactionData?.data ?? [];
          tempTransactionList = transactionData?.data ?? [];
        });
      } else {
        flutterToastBottom(
            LocaleKeys.internetMsg.tr);
      }
    }
  }
}
