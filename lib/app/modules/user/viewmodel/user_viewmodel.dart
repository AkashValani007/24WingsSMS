import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_create_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends BaseApiService {
  UserViewModel(BuildContext context) : super(context);

  Future<UserResponse?> getUser(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var timeMillisecond = prefs.getInt("user_timestamp_$iSocietyWingId");
    var timeStamp = "";
    if (timeMillisecond != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(timeMillisecond).toUtc();
      timeStamp =  DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
    }
    return await callApi(client.getUser(token ?? "", iSocietyWingId: iSocietyWingId,timeStamp:timeStamp));
  }

  // Future<HouseResponse?> getHouseList(int iSocietyWingId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("token");
  //
  //   return await callApi(
  //       client.getHouseList(token ?? "", iSocietyWingId: iSocietyWingId));
  // }
  Future<UserCreateResponse?> createUser(
    int iSocietyWingId,
    int userTypes,
    int isOwner,
    int isCommitteeMember,
    int iHouseId,
    String name,
    String number,
    String vPassword,
    String email,
    String bName,
    String bAddress,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.createUser(
        token ?? "",
        iSocietyWingId: iSocietyWingId,
        userTypes: userTypes,
        isOwner: isOwner,
        isCommitteeMember: isCommitteeMember,
        iHouseId: iHouseId,
        name: name,
        number: number,
        vPassword: vPassword,
        email: email,
        bName: bName,
        bAddress: bAddress,
      ),
    );
  }

  Future<UserCreateResponse?> updateUser(
      String name,
      int iUserId,
      String number,
      int iHouseId,
      String email,
      String bName,
      String bAddress,
      int userTypes) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return callApi(
      client.updateUser(token ?? "",
          iUserId: iUserId,
          name: name,
          number: number,
          iHouseId: iHouseId,
          email: email,
          bName: bName,
          bAddress: bAddress,
          iSocietyWingId: 0,
          userTypes: userTypes),
      // iSocietyWingId: userData.iSocietyWingId ?? 0,userTypes:userTypes),
    );
  }

  Future<UserCreateResponse?> editUser(
      int iUserId,
      String vUserName,
      String vEmail,
      int iGender,
      String vBusinessName,
      String vBusinessAddress,
      String dtDOB) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return callApi(
      client.editUser(token ?? "",
          iUserId: iUserId,
          vUserName: vUserName,
          vEmail: vEmail,
          iGender: iGender,
          vBusinessName: vBusinessName,
          vBusinessAddress: vBusinessAddress,
          dtDOB: dtDOB),
      // iSocietyWingId: userData.iSocietyWingId ?? 0,userTypes:userTypes),
    );
  }

  Future<UserCreateResponse?> deleteUser(int iUserId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return callApi(
      client.deleteUser(token ?? "", iUserId: iUserId),
    );
  }
}
