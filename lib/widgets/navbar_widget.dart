import 'package:attendance_tracker/controllers/navbar_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:attendance_tracker/widgets/navbar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarWidget extends BaseWidget implements PreferredSizeWidget {
  final String currentPage;

  const NavbarWidget({
    Key? key,
    required this.currentPage
  });

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.find();
    
    return AppBar(
      toolbarHeight: preferredSize.height, // Set the height of the AppBar
      backgroundColor: AppColors.NAVBARCOLOR,
      elevation: 0, // Optional: remove the shadow below the AppBar
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavbarIconWidget(
              icon: AppIcons.SCANICON, 
              controller: controller, 
              label: 'Scan', 
              navRoute: Routes.SCAN,
              currentPage: currentPage,
            ),
            NavbarIconWidget(
              icon: AppIcons.HISTORY, 
              controller: controller, 
              label: 'History', 
              navRoute: Routes.HISTORY,
              currentPage: currentPage,
            ),
            NavbarIconWidget(
              icon: AppIcons.LEAVEICON, 
              controller: controller, 
              label: 'Leave', 
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Set a fixed height
}
