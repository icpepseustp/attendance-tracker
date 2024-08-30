import 'package:attendance_tracker/bindings/base_binding.dart';
import 'package:attendance_tracker/controllers/history_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:get/get.dart';

class HistoryBinding extends BaseBinding{
  @override
  void dependencies(){
    Get.lazyPut<HistoryController>(
      () => HistoryController(
        Get.find<FirestoreService>()
      )
    );

  }
}