import 'package:attendance_tracker/controllers/settings_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends BaseView<SettingsController> {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: NavbarWidget(currentPage: Routes.SETTINGS),
      backgroundColor: AppColors.BGCOLOR,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
        children: [
          InkWell(
            onTap: controller.handleBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.LEAVEICON,
                    color: AppColors.NAVBARCOLOR,
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Back to selection',
                    style: AppTextStyles.SETTINGSTEXTSTYLE,
                  )
                ],
              ),
            )
          )
        ]
      ),
      )
    );
  }
}