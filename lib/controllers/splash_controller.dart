import 'dart:async';

import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


class SplashController extends BaseController {

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    debugPrint("SplashController onInit");
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("SplashController onReady");
    _startTimer();
  }

  void _startTimer() {
    debugPrint("SplashController startTimer");
    _timer = Timer(const Duration(milliseconds: 2000), (() => _launchEvents()));
  }

  void _launchEvents() {
      debugPrint("SplashController Timer Stops");
      Get.offAndToNamed(Routes.EVENTS);
      _timer.cancel();
  }

  @override
  void onClose() {
    debugPrint("SplashController onClose");
    super.onClose();
  }
}