import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';
import 'package:maintaince/app/modules/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTransactionView extends StatefulWidget {
  const MyTransactionView({Key? key}) : super(key: key);

  @override
  _MyTransactionViewState createState() => _MyTransactionViewState();
}

class _MyTransactionViewState extends State<MyTransactionView> {
  List<TransactionData> transactionList = [];
  List<TransactionData> tempTransactionList = [];
  late TransactionViewModel _service;

  UserData? userData;
  String selectYear = "Select Year";

  @override
  void initState() {
    super.initState();
    _service = TransactionViewModel(context);
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
          LocaleKeys.myTransactions.tr,
          style: TextStyle(color: blackColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Visibility(
              visible: transactionList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactionList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.sp),
                          ),
                        ),
                        color: whiteColor,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 8.w,
                                  height: 66.h,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.sp),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('dd').format(
                                              DateFormat('yyyy-MM-dd').parse(
                                                  transactionList[index]
                                                          .dPaymentDate ??
                                                      "")),
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Text(
                                          DateFormat('MMMM').format(
                                              DateFormat('yyyy-MM-dd H:m:s')
                                                  .parse(transactionList[index]
                                                          .dtCreated ??
                                                      "0000-00-00 00:00:00")),
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: grayTextColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 6.h),
                                    child: Row(
                                      children: [
                                        /*Container(
                                          margin: EdgeInsets.symmetric(vertical: 10.sp),
                                          width: 50,
                                          height: 50,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: Image.asset(
                                                LocaleKeys.ic_dummy_user,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),*/
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                "${(transactionList[index].vHouseNo != null && transactionList[index].vHouseNo!.isNotEmpty ? "${transactionList[index].vHouseNo} - " : "")}${transactionList[index].vTransactionDetails ?? ""}",
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6.h,
                                              ),
                                              Text(
                                                DateFormat('MMMM').format(
                                                    DateFormat('yyyy-MM-dd')
                                                        .parse(transactionList[
                                                                    index]
                                                                .dPaymentDate ??
                                                            "")),
                                                style: TextStyle(
                                                  color: grayColor,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${transactionList[index].iTransactionType == 0 ? "+" : "-"}${transactionList[index].iAmount ?? 0}",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: transactionList[index]
                                                          .iTransactionType ==
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                        /*Image.asset(
                                          transactionList[index].iTransactionType == 0
                                              ? LocaleKeys.ic_amount_credit
                                              : LocaleKeys.ic_amount_debit,
                                          color: transactionList[index].iTransactionType == 0
                                              ? greenBorder
                                              : redBorder,
                                          fit: BoxFit.cover,
                                          height: 22.h,
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 3.w,
                              decoration: BoxDecoration(
                                color:
                                    transactionList[index].iTransactionType == 0
                                        ? Colors.green
                                        : Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.sp),
                                  bottomLeft: Radius.circular(6.sp),
                                ),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 2.h),
                              height: 66.h,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: transactionList.isEmpty,
              child: Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.noTransaction.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

    getMyTransaction();
  }

  void getMyTransaction() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var transactionData = await _service.getMyTransaction(userData!.iUserId!);
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

  Future flutterYearPicker(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.selectYear.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Get.back();
                        selectYear = "Select Year";
                        transactionList.clear();
                        transactionList.addAll(tempTransactionList);
                      });
                    },
                    child: Text(
                      LocaleKeys.clear.tr,
                      style: TextStyle(color: grayTextColor, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: size.height / 3,
            width: size.width,
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              children: [
                ...List.generate(
                  10,
                  (index) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectYear =
                            "${int.parse(DateFormat('yyyy').format(DateTime.now())) - index}";
                        transactionList = tempTransactionList
                            .where((element) =>
                                DateFormat('yyyy').format(
                                    DateFormat('yyyy-MM-dd')
                                        .parse(element.dtCreated ?? "")) ==
                                selectYear)
                            .toList();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0),
                      child: Chip(
                        label: Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            (int.parse(DateFormat('yyyy')
                                        .format(DateTime.now())) -
                                    index)
                                .toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
