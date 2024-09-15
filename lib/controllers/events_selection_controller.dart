import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/selected_option_model.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsSelectionController extends BaseController {
  EventsSelectionController(this._service);
  final FirestoreService _service;
  
  final Rx<SelectedOptionModel> selectedEvent = SelectedOptionModel(description: '', id: '').obs;

  // list of events to display on the page
  var eventsList = <Map<dynamic, dynamic>>[].obs;
  
  @override
  void onInit() async {
    super.onInit();
    final events = await getEvents();
    eventsList.addAll(events);
  }

  void handleEventClicked(String event, String eventId){
    selectedEvent.value = SelectedOptionModel(
      description: event, 
      id: eventId
    );
    Get.offAndToNamed(Routes.SCAN);
  }

  
  Future<List<Map<dynamic, dynamic>>> getEvents() async {
    try {
      final eventsSnapshot = await _service.getMainDoc(null, AppStrings.EVENTSCOLLECTION);
      return eventsSnapshot.docs.map((doc) {
        return {
          doc.get(AppStrings.EVENTDESCRIPTION): doc.get(AppStrings.EVENTID),
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching event descriptions: $e');
      return [];
    }
  }

}
