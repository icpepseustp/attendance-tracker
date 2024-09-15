import 'package:attendance_tracker/bindings/base_binding.dart';
import 'package:attendance_tracker/controllers/events_selection_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:get/get.dart';

class EventsSelectionBinding extends BaseBinding {
  @override
  void dependencies(){
    Get.put<EventsSelectionController>(
      EventsSelectionController(
        Get.find<FirestoreService>()
      ), 
      permanent: true
    );
  }
}