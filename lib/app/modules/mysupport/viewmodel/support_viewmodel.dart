import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/user/model/user_create_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Support_create_model.dart';
import '../model/Support_model.dart';

class SupportViewModel extends BaseApiService {
  SupportViewModel(BuildContext context) : super(context);

  Future<SupportResponse?> getSupport(int iUserId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
        client.getSupport(token ?? "", iUserId: iUserId));
  }

  Future<SupportCreateResponse?> createSupport(
      int iUserId,
    String vSupportDetails,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
      client.createSupport(
        token ?? "",
        iUserId: iUserId,
        vSupportDetails: vSupportDetails,
      ),
    );
  }
}
