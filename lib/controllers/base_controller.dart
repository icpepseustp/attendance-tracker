import 'dart:async';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BaseController extends GetxController {


  // store the selected event and the selected usage 
  static final Rx<SelectedOptionModel> selectedEvent = SelectedOptionModel(description: '', id: '').obs;
  static final Rx<SelectedOptionModel> selectedUsage = SelectedOptionModel(description: '', id: '').obs;

  // get the description of the selected event and selected usage
  final isEventAttendance = selectedUsage.value.description == AppStrings.EVENTATTENDANCE;
  final isBooklet = selectedUsage.value.description == AppStrings.BOOKLET;
  final isBorrowing = selectedUsage.value.description == AppStrings.BORROWCOMPONENTS;

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String formatTime(DateTime time) => DateFormat('HH:mm:ss').format(time);

  @protected
  void onShowAlert(String title, String message) {
    Timer(const Duration(milliseconds: 2000),
        (() => Get.snackbar(title, message)));
  }
  
  String getCurrentDate(){
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String getCurrentTime(){
    return DateFormat('HH:mm:ss').format(DateTime.now());
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