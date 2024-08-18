import 'package:attendance_tracker/bindings/base_binding.dart';
import 'package:attendance_tracker/controllers/scan_controller.dart';
import 'package:get/get.dart';

class ScanBinding extends BaseBinding {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(
      () => ScanController()
    );
  }
}