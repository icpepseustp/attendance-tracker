import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavbarIconWidget extends BaseWidget {
  final String icon;
  final String label;
  
  const NavbarIconWidget({
    Key? key,
    required this.icon,
    required this.label
  });

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.UNDERLINECOLOR,
            width: 5
          )
        )
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
          style: AppTextStyles.navIconLabelPoppins
        ),
      ],
    ),
    ),
    );
  }
}