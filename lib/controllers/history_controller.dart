import 'dart:async';

import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/controllers/booklet_controller.dart';
import 'package:attendance_tracker/controllers/borrow_controller.dart';
import 'package:attendance_tracker/controllers/event_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/booklet_history_model.dart';
import 'package:attendance_tracker/models/borrow_history_model.dart';
import 'package:attendance_tracker/models/event_history_model.dart';
import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:attendance_tracker/widgets/student_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryController extends BaseController {
  HistoryController(this._service)
    : _eventController = EventController(_service),
      _bookletController = BookletController(_service),
      _borrowController = BorrowController(_service);

  final FirestoreService _service;

    // initialize the controller for each usage
  final EventController _eventController;
  final BookletController _bookletController;
  final BorrowController _borrowController;

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
    debugPrint('${date}');
    if(isEventAttendance){
      final eventAttendanceHistory = await _eventController.fetchEventAttendanceForToday(null, date);
      debugPrint('$eventAttendanceHistory');
      studentHistoryDetails.value = eventAttendanceHistory;
      isLoading.value = false;
    } else if (isBooklet){
      final bookletHistory = await _bookletController.fetchBookletsClaimedToday(date);
      studentHistoryDetails.value = bookletHistory;
      isLoading.value = false;
    }
    else {
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

  Widget handleHistoryDisplay() {
  return isLoading.value
      ? const Center(child: CircularProgressIndicator())
      : StudentDetailsWidget(
        studentDetails: studentHistoryDetails,
        buildSubText: (HistoryModel student) => handleStudentDetails(student),
      );
  }

  Text handleStudentDetails (HistoryModel student) {
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
