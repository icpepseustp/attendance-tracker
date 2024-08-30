import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/event_history_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventController extends BaseController {

  EventController(this._service);
  
  final FirestoreService _service;


  Future<void> recordEventAttendance(String name, String studentId)async {
    final now = DateTime.now();
    
    final studentData = {
      AppStrings.STUDENT_NAME: name,
      AppStrings.STUDENT_ID: studentId,
      AppStrings.BORROWSTATUS: isBorrowing,
      AppStrings.CLAIMABLEBOOKLET: 4
    };

    final attendanceData = {
      AppStrings.DATE: formatDate(now),
      AppStrings.TIME: formatTime(now),
      AppStrings.EVENTID: BaseController.selectedEvent.value.id,
    };

    try {
      DocumentSnapshot? docSnapshot = await _service.getStudentById(studentId);

      DocumentReference docRef;

      // Check if documentSnapshot is null or does not exist
      if (docSnapshot == null || !docSnapshot.exists) {
        // Create a new document if not found
        docRef = await _service.createDoc(studentData);
      } else {
        docRef = docSnapshot.reference;
      }

      // Create the sub-document using the document reference ID
      await _service.createSubDoc(attendanceData, docRef.id, AppStrings.ATTENDANCECOLLECTION);

    } catch (e) {
      debugPrint('Error recording new dat:  $e');
    }
  }

  Future<List<EventHistoryModel>> fetchEventAttendanceForToday(String? query) async {
    try {
      final mainDocs = await _service.getMainDoc(query, AppStrings.STUDENTSCOLLECTION);
       
      List<EventHistoryModel> eventAttendanceList = [];
      
      await Future.wait(mainDocs.docs.map( (mainDoc) async {
        final subDocs = await _service.getSubDoc(mainDoc.id, AppStrings.ATTENDANCECOLLECTION, AppStrings.DATE, formatDate(DateTime.now()));
        eventAttendanceList.addAll(subDocs.docs.map( (subDoc) => EventHistoryModel.fromSnapshot(mainDoc, subDoc)));
      }));

      return eventAttendanceList;
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      return [];
  }
  }
  
  Text eventAlertDialog(String name, String studentId) {
    return  Text('Name: $name \nID Number: $studentId', style: AppTextStyles.QRDETECTEDDIALOG);
  }

  // Future<List<EventHistoryModel>> fetchEventAttendance(String? query) async {
  //   try {
  //     final studentDoc = await _service.getmain
  //   } catch (e) {
  //     debugPrint('Error fetching attendance data: $e');
  //     return [];
  //   }
  // }

}