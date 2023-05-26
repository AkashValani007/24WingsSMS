import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_crate_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchmenViewModel extends BaseApiService {
  WatchmenViewModel(BuildContext context) : super(context);

  Future<WatchmenResponse?> getWatchmen() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return await callApi(client.getWatchmen(token ?? "",
        iSocietyWingId: userData.wings[0].iSocietyWingId ?? 0));
  }

  Future<WatchmenCreateResponse?> createWatchmen(String vWatchmenName, String vWatchmenNumber, String vWatchmenAddress,int vWatchmenType) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return callApi(
      client.createWatchmen(token ?? "",
          vWatchmenName: vWatchmenName,
          vWatchmenNumber: vWatchmenNumber,
          vWatchmenAddress: vWatchmenAddress,
          vWatchmenType: vWatchmenType,
          iSocietyWingId: userData.wings[0].iSocietyWingId ?? 0,
          iOnDuty: 0),
    );
  }

  Future<WatchmenCreateResponse?> updateWatchmen(int iWatchmenId,String vWatchmenName, String vWatchmenNumber, String vWatchmenAddress,int vWatchmenType,int iOnDuty) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
    UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return callApi(
      client.updateWatchmen(token ?? "",
          iWatchmenId: iWatchmenId,
          vWatchmenName: vWatchmenName,
          vWatchmenNumber: vWatchmenNumber,
          vWatchmenAddress: vWatchmenAddress,
          vWatchmenType: vWatchmenType,
          iSocietyWingId: userData.wings[0].iSocietyWingId ?? 0,
          iOnDuty: iOnDuty),
    );
  }

  Future<WatchmenCreateResponse?> deleteWatchmen(int iWatchmenId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return callApi(
      client.deleteWatchmen(token??"", iWatchmenId: iWatchmenId),
    );
  }
}
