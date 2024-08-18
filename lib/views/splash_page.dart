import 'package:attendance_tracker/controllers/splash_controller.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:flutter/material.dart';

class SplashPage extends BaseView<SplashController> {
  
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("SplashPage initialized ${controller.initialized}");
    return Scaffold (
        body : Center (
      child: Container (
          color: AppColors.BGCOLOR,
          child: Align (
            alignment: Alignment.center,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.ICPEPLOGO,
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}