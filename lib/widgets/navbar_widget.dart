import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:attendance_tracker/widgets/navbar_icon_widget.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends BaseWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height, // Set the height of the AppBar
      backgroundColor: AppColors.NAVBARCOLOR,
      elevation: 0, // Optional: remove the shadow below the AppBar
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 45),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavbarIconWidget(icon: AppIcons.SCANICON, label: 'Scan'),
            SizedBox(width: 50),
            NavbarIconWidget(icon: AppIcons.HISTORY, label: 'History'),
            SizedBox(width: 50),
            NavbarIconWidget(icon: AppIcons.SETTINGS, label: 'Settings'),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Set a fixed height
}
