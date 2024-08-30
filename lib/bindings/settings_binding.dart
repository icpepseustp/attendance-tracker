import 'package:attendance_tracker/bindings/base_binding.dart';
import 'package:attendance_tracker/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends BaseBinding{
  @override
  void dependencies(){
    Get.lazyPut<SettingsController>(
      () => SettingsController()
    );
  }
}