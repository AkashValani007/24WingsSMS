import 'package:flutter/material.dart';
import 'package:maintaince/network/base_api_service.dart';

import '../model/constant_city_model.dart';

class ConstantCityViewModel extends BaseApiService {
  ConstantCityViewModel(BuildContext context) : super(context);

  Future<ConstantCityResponse?> constantCity() async {
    return await callApi(client.constantCity(), doShowLoader: true);
  }
}
