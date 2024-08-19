import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends BaseController {
  var isSelected = false.obs;

  Color handleIsSelected(String currentPage, String navRoute){
    isSelected.value = currentPage == navRoute;
    
    return isSelected.value ? AppColors.UNDERLINECOLOR : Colors.transparent;     
  }

  void handleOnTap(String route){
    Get.offAndToNamed(route);
  }
}