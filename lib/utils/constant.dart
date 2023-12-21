import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SnackBar snackBarBizapp() {
  return SnackBar(
    onVisible: (){
      HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
      HapticFeedback.heavyImpact();
    },
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    content: const Text("Error. Sila panggil Faiz (sebelum Faiz takde :p )", style: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18, color: Colors.white,
    )),
  );
}