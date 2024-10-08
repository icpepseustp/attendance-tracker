import 'package:attendance_tracker/controllers/navbar_controller.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavbarIconWidget extends BaseWidget {
  final String icon;
  final String label;
  final String? navRoute;  // Nullable navRoute
  final String? currentPage;  // Nullable currentPage
  final NavbarController controller;

  const NavbarIconWidget({
    Key? key,
    required this.icon,
    required this.label,
    this.navRoute,
    this.currentPage,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Use a default route if navRoute is null
          controller.handleOnTap(navRoute);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: controller.handleIsSelected(currentPage, navRoute),
                width: 5,
              ),
            ),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                width: 35,
                height: 35,
                color: AppColors.ICONCOLOR,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: AppTextStyles.NAVICONLABELPOPPINS,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
