import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_create_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/notice_create_model.dart';
import '../model/notice_model.dart';

class NoticeViewModel extends BaseApiService {
  NoticeViewModel(BuildContext context) : super(context);

  Future<NoticeResponse?> getNotice(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
        client.getNotice(token ?? "", iSocietyWingId: iSocietyWingId));
  }

  Future<NoticeCreateResponse?> createNotice(
      int iUserId,
    int iSocietyWingId,
    String vNoticeDetail,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
      client.createNotice(
        token ?? "",
        iUserId: iUserId,
        iSocietyWingId: iSocietyWingId,
        vNoticeDetail: vNoticeDetail,
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
    return await callApi(
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

  Future<NoticeCreateResponse?> updateNotice(
      int iNoticeId, String vNoticeDetail) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.updateNotice(
          token ?? "",
          iNoticeId: iNoticeId,
          vNoticeDetail: vNoticeDetail),
    );
  }

  Future<NoticeCreateResponse?> deleteNotice(int iNoticeId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
      client.deleteNotice(token ?? "", iNoticeId: iNoticeId),
    );
  }
}
