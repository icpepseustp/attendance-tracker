import 'dart:async';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {

  static final Rx<SelectedOptionModel> selectedEvent = SelectedOptionModel(description: '', id: '').obs;
  static final Rx<SelectedOptionModel> selectedUsage = SelectedOptionModel(description: '', id: '').obs;

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