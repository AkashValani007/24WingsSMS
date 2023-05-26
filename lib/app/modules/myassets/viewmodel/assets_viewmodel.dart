import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/assets_create_model.dart';
import '../model/assets_model.dart';


class AssetsViewModel extends BaseApiService {
  AssetsViewModel(BuildContext context) : super(context);

  Future<AssetsResponse?> getAssets(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
        client.getAssets(token ?? "", iSocietyWingId: iSocietyWingId));
  }

  Future<AssetsCreateResponse?> createAsset(
      int iUserId,
      int iSocietyWingId,
      String vAssetName,
      String iQty) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
      client.createAssets(
        token ?? "",
        iUserId: iUserId,
        iSocietyWingId: iSocietyWingId,
        vAssetName: vAssetName,
        iQty: iQty,
      ),
    );
  }

  Future<AssetsCreateResponse?> deleteAssets(int iAssetsId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
      client.deleteAssets(token ?? "", iAssetsId: iAssetsId));
  }


  Future<AssetsCreateResponse?> updateAssets(
      int iAssetsId,String vAssetName, String iQty) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.updateAssets(
          token ?? "",
          iAssetsId: iAssetsId,
          vAssetName: vAssetName,
          iQty: iQty),
    );
  }
}
