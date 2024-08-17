import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/routes/app_pages.dart';

class BaseController extends GetxController {
  @override
  onInit() {
    super.onInit();
  }

  @protected
  void onShowAlert(String title, String message) {
    Timer(const Duration(milliseconds: 2000),
        (() => Get.snackbar(title, message)));
  }
  

  void showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: Icon(
        backgroundColor == Colors.green ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}