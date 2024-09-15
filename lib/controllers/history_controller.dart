import 'dart:async';

import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/controllers/booklet_controller.dart';
import 'package:attendance_tracker/controllers/borrow_controller.dart';
import 'package:attendance_tracker/controllers/event_controller.dart';
import 'package:attendance_tracker/controllers/usage_selection_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/booklet_history_model.dart';
import 'package:attendance_tracker/models/borrow_history_model.dart';
import 'package:attendance_tracker/models/event_history_model.dart';
import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends BaseController {
  // Constructor for HistoryController
  HistoryController(this._service, this.usageSelectionController)
    : _eventController = EventController(_service),
      _bookletController = BookletController(_service, usageSelectionController),
      _borrowController = BorrowController(_service, usageSelectionController);

  final FirestoreService _service;
  final EventController _eventController;
  final BookletController _bookletController;
  final BorrowController _borrowController;
  final UsageSelectionController usageSelectionController;

  var isLoading = true.obs;
  var isSearching = false.obs; 
  final RxList<HistoryModel> studentHistoryDetails = <HistoryModel>[].obs;
  final TextEditingController dateController = TextEditingController();

  Timer? _debounce; 
  
  @override
  Future<void> onInit() async {
    super.onInit();
    dateController.text = getCurrentDate();
    await _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final String date = dateController.text.trim();
    if (usageSelectionController.selectedUsage.value.description == AppStrings.EVENTATTENDANCE) {
        final eventAttendanceHistory = await _eventController.fetchEventAttendanceForToday(null, date);
        debugPrint('$eventAttendanceHistory');
        studentHistoryDetails.value = eventAttendanceHistory;
        isLoading.value = false;
    } else if (usageSelectionController.selectedUsage.value.description == AppStrings.BOOKLET) {
      final bookletHistory = await _bookletController.fetchBookletsClaimedToday(date);
      studentHistoryDetails.value = bookletHistory;
      isLoading.value = false;
    } else {
      final borrowHistory = await _borrowController.fetchBorrowHistory(date);
      studentHistoryDetails.value = borrowHistory;
      isLoading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final initialDate = DateTime.tryParse(dateController.text.trim());
    
    DateTime? _picked = await showDatePicker(
      context: context, 
      initialDate: initialDate,
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if(_picked != null){
      dateController.text = _picked.toString().split(' ')[0];
      isLoading.value = true;
      await _fetchHistory();
    }
  }

  Text handleStudentDetails(HistoryModel student) {
    if (student is EventHistoryModel) {
      return Text(
        '${student.attendanceDate} \t ${student.attendanceTime}',
        style: AppTextStyles.STUDENTDETAILSSUBTEXT,
      );
    } else if (student is BookletHistoryModel) {
      return Text(
        '${student.booklets} booklets claimed',
        style: AppTextStyles.STUDENTDETAILSSUBTEXT,
      );
    } else if(student is BorrowHistoryModel) {
      return Text(
        '${student.date} : ${student.dateReturned} \ncomponent: ${student.componentBorrowed}',
        style: AppTextStyles.STUDENTDETAILSSUBTEXT,
      );
    } else {
      return Text(
        'No additional details available',
        style: AppTextStyles.STUDENTDETAILSSUBTEXT,
      );
    }
  }

  @override
  void onClose(){
    _debounce?.cancel();
    super.onClose();
  }
}
