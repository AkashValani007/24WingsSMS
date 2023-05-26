import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:maintaince/app/constant/common.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_model.dart';
import 'package:maintaince/app/modules/Hallbooking/view/booking_complete.dart';
import 'package:maintaince/app/modules/Hallbooking/view/booking_upcoming.dart';
import 'package:maintaince/app/modules/home/view/home_view.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/routes/app_pages.dart';
import 'package:maintaince/generated/locales.g.dart';
import 'package:maintaince/util/connectivity_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../addbookableproperty/model/bookable_property_model.dart';
import '../viewmodel/booking_viewmodel.dart';

class BookingView extends StatefulWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  dynamic arguments = Get.arguments;

  List<BookableProperty> listBookableProperty=[];
  late BookableProperty bookableProperty;
  List<HallBooking> bookingList = [];
  late BookingViewModel _service;
  MediaQueryData? queryData;

  UserData? userData;
  bool isEditable = false;

  @override
  // void initState() {
  //   super.initState();
  //   _service = BookingViewModel(context);
  //
  //   if (arguments != null) {
  //     bookableProperty = arguments['propertyData'];
  //     listBookableProperty = arguments['listBookableProperty'];
  //   }
  //   getUserData();
  // }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    queryData = MediaQuery.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: greyBackground,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.5,
          iconTheme: IconThemeData(
            color: blackColor, //change your color here
          ),
          title: Text(
            LocaleKeys.booking.tr,
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
              // TabBarView(
              //     children: [
              //       TodayBooking(),
              //       TodayBooking(),
              //       BookingView(),
              //     ]),
              PreferredSize(
                preferredSize: const Size.fromHeight(600),
                child: TabBar(
                  automaticIndicatorColorAdjustment: false,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: pinkColor,
                  ),
                  indicatorPadding: const EdgeInsets.all(10),
                  //indicatorWeight: 10,
                  //isScrollable: true,

                  //indicatorColor: Colors.black,
                  labelColor: Colors.white,

                  unselectedLabelColor: blackColor,
                  unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  tabs: const [
                    Tab(child: Text('Completed',style: TextStyle(fontSize: 12),)),
                    Tab(child: Text('Upcoming',style: TextStyle(fontSize: 12),)),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                    children: [
                      TodayBooking(),
                      UpcomingBooking(),
                    ]),
              ),
              
              // if (bookingList.isEmpty) Expanded(
              //   child: Center(
              //     child: Text(
              //       LocaleKeys.noBookingFound.tr,
              //       style: TextStyle(
              //         color: blackColor,
              //         fontSize: 16.sp,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ) else Expanded(
              //   child: ListView.builder(
              //     physics: const BouncingScrollPhysics(),
              //     itemCount: bookingList.length,
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int index) {
              //       var data = bookingList[index];
              //       return Card(
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.sp),),),
              //         color: whiteColor,
              //         child: Stack(
              //           children: [
              //             Row(
              //               children: [
              //                 SizedBox(width: 8.w, height: 66.h,),
              //
              //                 Expanded(
              //                   child: Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         horizontal: 10.w, vertical: 6.h),
              //                     child: Row(
              //                       children: [
              //                         /*Container(
              //                                 margin: EdgeInsets.symmetric(vertical: 10.sp),
              //                                 width: 50,
              //                                 height: 50,
              //                                 child: GestureDetector(
              //                                   onTap: () {},
              //                                   child: ClipRRect(
              //                                     borderRadius: BorderRadius.circular(25),
              //                                     child: Image.asset(
              //                                       LocaleKeys.ic_dummy_user,
              //                                       fit: BoxFit.cover,
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 width: 16.w,
              //                               ),*/
              //                         Expanded(
              //                           child: Column(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             mainAxisSize: MainAxisSize.max,
              //                             children: [
              //                               Center(
              //                                 child: Text(
              //                                   data.vBookingType.toString(),
              //                                   textAlign: TextAlign.start,
              //                                   style: TextStyle(
              //                                     color: blackColor,
              //                                     fontSize: 12.sp,
              //                                     fontWeight: FontWeight.bold,
              //                                   ),
              //                                 ),
              //                               ),
              //                               Text(LocaleKeys.date.tr,
              //                                 style: TextStyle(
              //                                     fontSize: 10.sp,
              //                                     color: grayHintColor,
              //                                     //fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 5.h,
              //                               ),
              //                               Text(data.dtBooking.toString(),
              //                                 textAlign: TextAlign.start,
              //                                 style: TextStyle(
              //                                     fontSize: 12.sp,
              //                                     color: blackColor,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                               SizedBox(
              //                                 height: 6.h,
              //                               ),
              //                               Text("Mobile Number",
              //                                 style: TextStyle(
              //                                     fontSize: 10.sp,
              //                                     color: grayHintColor,
              //                                     //fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 5.h,
              //                               ),
              //                               Text(
              //                                 data.vMobile.toString(),
              //                                 textAlign: TextAlign.start,
              //                                 style: TextStyle(
              //                                   color: blackColor,
              //                                   fontSize: 12.sp,
              //                                   fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 6.h,
              //                               ),
              //                               Text(LocaleKeys.addressHall.tr,
              //                                 style: TextStyle(
              //                                     fontSize: 10.sp,
              //                                     color: grayHintColor,
              //                                     //fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 5.h,
              //                               ),
              //                               Text(data.vAddress.toString(),
              //                                  textAlign: TextAlign.start,
              //                                 style: TextStyle(
              //                                   color: blackColor,
              //                                   fontSize: 12.sp,
              //                                     fontWeight: FontWeight.bold
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 6.h,
              //                               ),
              //                               Text(LocaleKeys.advance.tr,
              //                                 style: TextStyle(
              //                                     fontSize: 10.sp,
              //                                     color: grayHintColor,
              //                                     //fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 5.h,
              //                               ),
              //                               Text(data.iAdvance.toString(),
              //                                 textAlign: TextAlign.start,
              //                                 style: TextStyle(
              //                                     color: blackColor,
              //                                     fontSize: 12.sp,
              //                                     fontWeight: FontWeight.bold
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                         /*Image.asset(
              //                                 transactionList[index].iTransactionType == 0
              //                                     ? LocaleKeys.ic_amount_credit
              //                                     : LocaleKeys.ic_amount_debit,
              //                                 color: transactionList[index].iTransactionType == 0
              //                                     ? greenBorder
              //                                     : redBorder,
              //                                 fit: BoxFit.cover,
              //                                 height: 22.h,
              //                               ),*/
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Container(
              //               width: 3.w,
              //               decoration: BoxDecoration(
              //                 color: pinkColor,
              //                 borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(6.sp),
              //                   bottomLeft: Radius.circular(6.sp),
              //                 ),
              //               ),
              //               margin: EdgeInsets.symmetric(vertical: 2.h),
              //               height: 180.h,
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),


            ],
          ),
        ),
        // floatingActionButton: Visibility(
        //   visible: isEditable,
        //   child: Align(
        //     alignment: const Alignment(0.85, 0.94),
        //     child: FloatingActionButton(
        //       onPressed: () async {
        //         Map<String, dynamic> map = {
        //           'propertyData': bookableProperty,
        //           'listBookableProperty': listBookableProperty
        //         };
        //         var result = await Get.toNamed(Routes.BOOKING_CREATE,arguments: map);
        //         if (result != null) {
        //           setState(() {
        //             bookingList.add(result);
        //           });
        //
        //         }
        //       },
        //       backgroundColor: pinkColor,
        //       child: Icon(
        //         Icons.add,
        //         color: whiteColor,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    var wingList = userData!.wings;
    if (wingList.isNotEmpty) {
      var temp = wingList.where((element) =>
      element.iUserTypeId == 1 ||
          element.iUserTypeId == 2 ||
          element.iUserTypeId == 3);
      if (temp.isNotEmpty) {
        setState(() {
          isEditable = true;
        });
      }
    }
    getBookings();
  }

  void getBookings() async {
    if (ConnectivityUtils.instance.hasInternet) {
      var bookingData = await _service.getBooking(bookableProperty.iSBookablePropertyId!);
      if (bookingData?.isSuccess ?? false) {
        setState(() {
          bookingList = bookingData?.data ?? [];
          print("bookingList${bookingList.length}");
        });
      } else {
        flutterToastBottom(LocaleKeys.internetMsg);
      }
    }
  }
}
