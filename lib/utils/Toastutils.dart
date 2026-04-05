import 'package:flutter/material.dart';

class ToastUtils {
  static bool _isShowing = false;
  static void showToast(BuildContext context, String message) {
    if(_isShowing) return;
    _isShowing = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 180,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(40)
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        content: Text(message,textAlign: TextAlign.center,),
      ),
    );
    Future.delayed(Duration(seconds: 3), () {
      _isShowing = false;
    });
  }
}