import 'package:attendance_tracker/controllers/usage_selection_controller.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/selection_option_widget.dart';
import 'package:flutter/material.dart';

class UsageSelectionPage extends BaseView<UsageSelectionController> {
  const UsageSelectionPage({Key? key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.BGCOLOR,
      body: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.85,
          height: 400,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select usage for scanner', 
                style: AppTextStyles.SELECTEVENTLABEL,
              ),
              Expanded(
            child: ListView.builder(
                itemCount: controller.usageSelectionOptions.length,
                itemBuilder: (context, index) {
                  final usage = controller.usageSelectionOptions[index];
                  final usageDescription = usage.description;
                  final usageId = usage.id;

                  return Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: SelectionOptionWidget(
                    optionDescription: usageDescription,
                    optionId: usageId, 
                    onPressed: (usageDescription, usageId) => controller.handleUsageOptionClicked(usageDescription, usageId)
                    )
                );
                }))
            ],
          ),
        ),
      ),
    );
  }
}