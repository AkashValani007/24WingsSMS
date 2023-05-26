import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maintaince/app/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpDownPageLimit {
  final int upLimit;
  final int downLimit;

  const UpDownPageLimit(this.upLimit, this.downLimit);
}

class UpDownButtonEnableState {
  final bool upState;
  final bool downState;

  const UpDownButtonEnableState(this.upState, this.downState);
}

int typecast(Map<String, dynamic> json, String key) {
  return json.containsKey(key) && json[key] != null
      ? json[key] is int
          ? json[key]
          : int.parse(json[key])
      : 0;
}

Future<Locale> getLocale() async {
  final prefs = await SharedPreferences.getInstance();
  var isLanguage = prefs.getString("vLanguage");
  if (isLanguage != null) {
    switch (isLanguage) {
      case "en":
        return const Locale('en', 'US');
      case "gu":
        return const Locale('gu', 'IN');
      case "hi":
        return const Locale('hi', 'IN');
    }
  }
  return const Locale('en', 'US');
}


AppDatabase? appDatabase;

Future<AppDatabase> databaseInitialise() async {
  appDatabase ??=
      await $FloorAppDatabase.databaseBuilder('24_wings.db').build();
  return appDatabase!;
}

void flutterToastTop(String errorMessage) {
  Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void flutterToastBottom(errorMessage) {
   Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void flutterToastBottomGreen(errorMessage) {
  Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
