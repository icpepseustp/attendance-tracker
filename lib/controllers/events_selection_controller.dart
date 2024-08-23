import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsSelectionController extends BaseController {
  EventsSelectionController(this._service);
  final FirestoreService _service;

  var eventsList = <Map<dynamic, dynamic>>[].obs;
  
  @override
  void onInit() async {
    super.onInit();
    final events = await _service.getEvents();
    eventsList.addAll(events);
  }

  void handleEventClicked(String event){
    BaseController.selectedEvent.value = event;
    Get.offAndToNamed(Routes.SCAN);
  }

  Widget handleEventsLoaded() {
    return eventsList.isNotEmpty
        ? Expanded(
            child: ListView.builder(
                itemCount: eventsList.length,
                itemBuilder: (context, index) {
                  final event = eventsList[index];
                  final eventDescription = event.keys.first;

                  return Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: ElevatedButton(
                    onPressed: () => handleEventClicked(eventDescription),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.NAVBARCOLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                    ),
                    child: Text(
                      eventDescription,
                      style: AppTextStyles.event,
                      textAlign: TextAlign.center
                    ),
                  ),
                );
                }))
        : Expanded(
            child: Center(
              child: const CircularProgressIndicator(),
            )
          );
  }
}
