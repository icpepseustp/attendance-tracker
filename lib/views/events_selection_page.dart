import 'package:attendance_tracker/controllers/events_selection_controller.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsSelectionPage extends BaseView {
  const EventsSelectionPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final EventsSelectionController controller = Get.find();

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
                'Select current event',
                style: AppTextStyles.selectEventLabel,
              ),
              Obx(() => controller.handleEventsLoaded())
            ],
          ),
        ),
      ),
    );
  }
}
