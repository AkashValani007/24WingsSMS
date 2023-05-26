import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/password/model/change_password_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordViewModel extends BaseApiService {
  ChangePasswordViewModel(BuildContext context) : super(context);

  Future<ChangePasswordResponse?> changePassword(
      String oldPass, String newPass) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return callApi(client.changePassword(token ?? "",
        vPassword: oldPass, nVPassword: newPass));
  }
}
