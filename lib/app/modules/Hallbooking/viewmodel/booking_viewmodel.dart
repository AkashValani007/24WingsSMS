import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_create_model.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingViewModel extends BaseApiService {
  BookingViewModel(BuildContext context) : super(context);

  Future<BookingResponse?> getBooking(int iSBookablePropertyId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(client.getBooking(token ?? "",
        iSBookablePropertyId: iSBookablePropertyId));
  }

  Future<UserResponse?> getUser(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var timeMillisecond = prefs.getInt("user_timestamp_$iSocietyWingId");
    var timeStamp = "";
    if (timeMillisecond != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(timeMillisecond);
      timeStamp = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
    }
    return await callApi(client.getUser(token ?? "",
        iSocietyWingId: iSocietyWingId, timeStamp: timeStamp));
  }

  Future<BookingCreateResponse?> createBooking(
      String iSBookablePropertyId,
      String dtBooking,
      int iUserId,
      String vUserName,
      String vMobile,
      String vAltMobile,
      String vAddress,
      String iBookingTypeId,
      String iAdvance,
      String iRent) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
      client.createBooking(token ?? "",
          iSBookablePropertyId: iSBookablePropertyId,
          dtBooking: dtBooking,
          iUserId: iUserId,
          vUserName: vUserName,
          vMobile: vMobile,
          vAltMobile: vAltMobile,
          vAddress: vAddress,
          iBookingTypeId: iBookingTypeId,
          iAdvance: iAdvance,
          iRent: iRent),
    );
  }
}
