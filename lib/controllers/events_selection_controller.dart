import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/selection_option_widget.dart';
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

  void handleEventClicked(String event, String eventId){
    BaseController.selectedEvent.value = SelectedOptionModel(
      description: event, 
      id: eventId
    );
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
                  final eventId = event[eventDescription];

                  return Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: SelectionOptionWidget(
                    optionDescription: eventDescription,
                    optionId: eventId, 
                    onPressed: (eventDescription, eventId) => handleEventClicked(eventDescription, eventId))
                );
                }))
        : Expanded(
            child: Center(
              child: const CircularProgressIndicator(),
            )
          );
  }
}
