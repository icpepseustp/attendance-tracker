import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:get/get.dart';

class UsageSelectionController extends BaseController {
  List<SelectedOptionModel> usageSelectionOptions = [
    SelectedOptionModel(
      description: AppStrings.BOOKLET, 
      id: ''
    ),
    SelectedOptionModel(
      description: AppStrings.EVENTATTENDANCE, 
      id: ''
    ),
    SelectedOptionModel(
      description: AppStrings.BORROWCOMPONENTS, 
      id: ''
    ),
  ];

  final Rx<SelectedOptionModel> selectedUsage = SelectedOptionModel(description: '', id: '').obs;

  void handleUsageOptionClicked(String usageDescription, String usageId){
    selectedUsage.value = SelectedOptionModel(
      description: usageDescription, 
      id: usageId
    );
    Get.offAndToNamed(
      usageDescription == AppStrings.EVENTATTENDANCE ? Routes.EVENTS : Routes.SCAN
    );
  }


}