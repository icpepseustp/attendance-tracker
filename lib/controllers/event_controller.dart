import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventController extends BaseController {

  EventController(this._service);
  
  final FirestoreService _service;


  Future<void> recordEventAttendance(String name, String studentId)async {
    final now = DateTime.now();
    
    final studentData = {
      AppStrings.STUDENT_NAME: name,
      AppStrings.STUDENT_ID: studentId,
      AppStrings.BORROWSTATUS: isBorrowing,
    };

    final attendanceData = {
      AppStrings.DATE: formatDate(now),
      AppStrings.TIME: formatTime(now),
      AppStrings.EVENTID: BaseController.selectedEvent.value.id,
    };

    try {
      final docRef = await _service.getOrCreateDocumentId(studentData, studentId);

      await _service.createSubDoc(attendanceData, docRef.id, AppStrings.ATTENDANCECOLLECTION);

    } catch (e) {
      debugPrint('Error recording new dat:  $e');
    }
  }
  

  Text eventAlertDialog(String name, String studentId) {
    return  Text('Name: $name \nID Number: $studentId', style: AppTextStyles.QRDETECTEDDIALOG);
  }


}