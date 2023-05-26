import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/vehicle/model/vehicle_create_model.dart';
import 'package:maintaince/app/modules/vehicle/model/vehicle_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleViewModel extends BaseApiService {
  VehicleViewModel(BuildContext context) : super(context);

  Future<VehicleResponse?> getVehicle(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
        client.getVehicle(token ?? "", iSocietyWingId: iSocietyWingId));
  }

  Future<VehicleCreateResponse?> createVehicle(
      int iUserWingId, int iVehicleType, String vVehicleNumber) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.createVehicle(token ?? "",
          iUserWingId: iUserWingId,
          iVehicleType: iVehicleType,
          vVehicleNumber: vVehicleNumber),
    );
  }

  Future<VehicleCreateResponse?> updateVehicle(
       int iVehicleId,int iVehicleType, String vVehicleNumber) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return callApi(
      client.updateVehicle(token ?? "",
          iVehicleId: iVehicleId,
          iVehicleType: iVehicleType,
          vVehicleNumber: vVehicleNumber),
    );
  }

  Future<VehicleCreateResponse?> deleteVehicle(int iVehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return callApi(
      client.deleteVehicle(token??"", iVehicleId: iVehicleId),
    );
  }


}
