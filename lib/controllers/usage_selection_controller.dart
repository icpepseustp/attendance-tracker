import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:get/get.dart';

class UsageSelectionController extends BaseController {
  List<SelectedOptionModel> usageSelectionOptions = [
    SelectedOptionModel(
      description: 'Booklet', 
      id: ''
    ),
    SelectedOptionModel(
      description: 'Event attendance', 
      id: ''
    ),
    SelectedOptionModel(
      description: 'Borrow Component', 
      id: ''
    ),
  ];

  void handleUsageOptionClicked(String usageDescription, String usageId){
    BaseController.selectedUsage.value = SelectedOptionModel(
      description: usageDescription, 
      id: usageId
    );
    Get.toNamed(Routes.EVENTS);
  }


}