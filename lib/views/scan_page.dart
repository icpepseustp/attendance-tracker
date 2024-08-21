import 'package:attendance_tracker/controllers/scan_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:attendance_tracker/widgets/scanner_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends BaseView<ScanController> {
  const ScanPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(currentPage: Routes.SCAN),
      body: Stack(
        children: [
           MobileScanner(
            controller: controller.mobileScannerController,
            onDetect: (capture) => controller.onQrDetect(context, capture),
          ),
          
          ScannerOverlayWidget(),
          Positioned(
            bottom: 30,
            width: MediaQuery.sizeOf(context).width * 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center, // Center items within the Row
                children: [
                  SvgPicture.asset(
                    AppIcons.ZOOMIN,
                    color: Colors.black,
                    width: 30,
                    height: 30,
                  ),
                  Expanded(
                    child: Obx(
                      () => SliderTheme(
                        data: SliderThemeData(
                            activeTrackColor: AppColors.UNDERLINECOLOR, // Color of the active part of the track
                            inactiveTrackColor: AppColors.UNDERLINECOLOR, // Color of the inactive part of the track
                            thumbColor: AppColors.UNDERLINECOLOR, // Color of the thumb (the draggable part)
                            overlayColor: AppColors.UNDERLINECOLOR.withOpacity(0.2), // Color of the overlay when dragging
                        ), 
                        child: Slider(
                        value: controller.overlaySize.value,
                        min: 0.2, // Minimum size (20%)
                        max: 1.0, // Maximum size (100%)
                        onChanged: controller.handleDisplaySizeChange,
                      ),) 
                    ),
                  ),
                  SvgPicture.asset(
                    AppIcons.ZOOMOUT,
                    color: Colors.black,
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            )
          ),
            Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child:  InkWell(
                onTap: controller.toggleTorch,
                child:  Obx(
                  () => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(3.1459),
                    child: SvgPicture.asset(
                      controller.getTorchIcon(),
                      color: AppColors.ICONCOLOR,
                      width: 60,
                      height: 60,
                    )
                  )
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
