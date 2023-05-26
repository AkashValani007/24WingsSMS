import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/google_font.dart';
import '../../../routes/app_pages.dart';
import '../../transaction/model/transaction_model.dart';

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({Key? key}) : super(key: key);

  @override
  _MaintenanceViewState createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  List<TransactionData> transactionList = [];
  List<TransactionData> tempTransactionList = [];
  List<TransactionData> selectTransactionList = [];

  List<WingData> wingList = [];
  List<int> years = [];
  List<int> months = [1,2,3,4,5,6,7,8,9,10,11,12];
  WingData? wing;

  String vStartDate = "2022-12-01";
  int iType = 1; // Only Maintenance Data

  late TransactionViewModel _service;
  DateTime? selectedMonth;
  int? year ;
  int? month ;
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _service = TransactionViewModel(context);
    year = DateTime.now().year;
    month = DateTime.now().month;
    selectedMonth = DateTime(year!, month!, 1);
    //print("Month ==> $month");
    var firstYear = year!-1;
    while (firstYear != year!+2) {
      years.add(firstYear);
      firstYear++;
    }

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
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Card(
              child: Column(
                children: [
                  Visibility(
                    visible:true,
                    child: Container(
                      margin: EdgeInsets.only(left: 16.w, right: 16.w),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Column(
                        children: [
                          Visibility(
                            visible: wingList.length != 1,
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
                                        hint: Text( LocaleKeys.selectWing.tr),
                                        value: wing,
                                        items: wingList.map((WingData value) {
                                          return DropdownMenuItem<WingData>(
                                            value: value,
                                            child: Text(
                                              '${value.vSocietyName} - ${ LocaleKeys.wing.tr} ${value.vWingName}',
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
                          Visibility(
                            visible: wingList.length != 1,
                            child: SizedBox(
                              height: 10.h,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.selectYear.tr,
                                      style: TextStyle(
                                          fontSize: 16.sp, color: grayTextColor),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    wingList.isEmpty
                                        ? Container()
                                        : DropdownButton<int>(
                                      hint: Text( LocaleKeys.selectYear.tr),
                                      value: year,
                                      items: years.map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            '$value',
                                            style:
                                            TextStyle(color: blackColor),
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          year = value;
                                          selectedMonth = DateTime(year!, month!, 1);
                                          vStartDate = DateFormat('yyyy-MM-dd').format(selectedMonth!);
                                          getTransaction();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.selectMonth.tr,
                                      style: TextStyle(
                                          fontSize: 16.sp, color: grayTextColor),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    wingList.isEmpty
                                        ? Container()
                                        : DropdownButton<int>(
                                      hint: Text(LocaleKeys.selectMonth.tr),
                                      value: month,
                                      items: months.map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            '$value',
                                            style:
                                            TextStyle(color: blackColor),
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          month = value;
                                          selectedMonth = DateTime(year!, month!, 1);
                                          vStartDate = DateFormat('yyyy-MM-dd').format(selectedMonth!);
                                          getTransaction();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
            SizedBox(
              height: 40.h,
            ),
          ]),
        ),
      ),

      floatingActionButton: Visibility(
        visible: wing!.iUserTypeId == 1 || wing!.iUserTypeId == 2 || wing!.iUserTypeId == 3|| wing!.iUserTypeId == 4,
        child: Align(
          alignment: const Alignment(0.85, 0.94),
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(Routes.MAINTAINANCE_CREATE);
              if (result != null) {
                setState(() {
                  // userList.add(result);
                });
              }
            },
            backgroundColor: pinkColor,
            child: Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget gridHouseItem(TransactionData transactionData) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: selectTransactionList.contains(transactionData)
              ? greenBorder
              : transactionData.iTransactionId == 0
              ? hintColor
              : colorGreen,
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
                color: transactionData.iTransactionId == 0
                    ? blackColor
                    : whiteColor,
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
                  color: transactionData.iTransactionId == 0
                      ? blackColor
                      : whiteColor,
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
