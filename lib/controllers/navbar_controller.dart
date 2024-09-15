import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends BaseController {
  var isSelected = false.obs;

  Color handleIsSelected(String? currentPage, String? navRoute) {
    // Safely compare nullable strings
    isSelected.value = (currentPage != null && navRoute != null) && (currentPage == navRoute);
    
    return isSelected.value ? AppColors.UNDERLINECOLOR : Colors.transparent;
  }

  void handleOnTap(String? route) {
    if (route != null) {
        Get.offAndToNamed(route);
    } else {
      Get.offAllNamed(Routes.USAGE);
    }
  }
}
