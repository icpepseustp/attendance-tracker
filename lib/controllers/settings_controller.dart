import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsController extends BaseController {
  void handleBack() {
    BaseController.selectedEvent.update((model) {
      model?.description = '';
      model?.id = '';
    });

    BaseController.selectedUsage.update((model) {
      model?.description = '';
      model?.id = '';
    });

    Get.offAllNamed(Routes.USAGE);
  }
}