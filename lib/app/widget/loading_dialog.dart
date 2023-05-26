import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maintaince/app/constant/LocalColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingDialog {
  static final instance = LoadingDialog._();

  LoadingDialog._();

  bool _isVisible = false;

  void show(BuildContext context) {
    if (_isVisible) return;
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          backgroundColor: transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: SpinKitCircle(
              color: themeColor,
              size: 64,
            ),
          ),
        ),
      ),
    );
    _isVisible = true;
  }

  void dismiss(BuildContext context) {
    if (_isVisible) {
      Navigator.of(context).pop();
      _isVisible = false;
    }
  }
}

