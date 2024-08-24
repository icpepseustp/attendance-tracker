import 'package:attendance_tracker/bindings/base_binding.dart';
import 'package:attendance_tracker/controllers/usage_selection_controller.dart';
import 'package:get/get.dart';

class UsageSelectionBinding extends BaseBinding {
  @override
  void dependencies(){
    Get.lazyPut<UsageSelectionController>(
      () => UsageSelectionController()
    );
  }
}