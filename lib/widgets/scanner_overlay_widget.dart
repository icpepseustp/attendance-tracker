import 'package:attendance_tracker/controllers/scan_controller.dart';
import 'package:attendance_tracker/painters/scanner_overlay_painter.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScannerOverlayWidget extends BaseWidget{
  @override
  Widget build(BuildContext context){
    final ScanController controller = Get.find();
    
    return Obx(() => CustomPaint(
      painter: ScannerOverlayPainter(overlaySize: controller.overlaySize.value), 
      child: Container(),
    ));
  }
}