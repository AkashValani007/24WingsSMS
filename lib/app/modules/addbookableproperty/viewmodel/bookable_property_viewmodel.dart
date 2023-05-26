import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bookable_property_create_model.dart';
import '../model/bookable_property_model.dart';

class BookablePropertyViewModel extends BaseApiService {
  BookablePropertyViewModel(BuildContext context) : super(context);

  Future<BookablePropertyResponse?> getBookableProperty(String vSocietyWingIds) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
        client.getBookableProperty(token ?? "", vSocietyWingIds: vSocietyWingIds));
  }

  Future<BookablePropertyCreateResponse?> createBookableProperty(
      int iSocietyId,
      int iUserId,
      String vSocietyWingIds,
      String vPropertyName,) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
      client.createBookableProperty(token ?? "",
          iSocietyId: iSocietyId,
          iUserId: iUserId,
        vSocietyWingIds: vSocietyWingIds,
        vPropertyName: vPropertyName,
    ));
  }

  Future<BookablePropertyCreateResponse?> updateBookableProperty(
      int iSBookablePropertyId, String vPropertyName) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.updateBookableProperty(
          token ?? "",
          iSBookablePropertyId: iSBookablePropertyId,
          vPropertyName: vPropertyName),
    );
  }


}
