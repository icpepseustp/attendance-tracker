import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsController extends BaseController {
  void handleBack() {
    Get.offAllNamed(Routes.EVENTS);
  }
}