import 'package:flutter/material.dart';

import '../../../../network/base_api_service.dart';
import '../model/login_model.dart';

class LoginViewModel extends BaseApiService {
  LoginViewModel(BuildContext context) : super(context);

  Future<LoginResponse?> login(
      String vMobile, String vPassword) async {
    return callApi(
      client.login(
        vMobile: vMobile,
        vPassword: vPassword
      ),
    );
  }
}
