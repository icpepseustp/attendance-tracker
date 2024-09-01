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
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Timer? _debounce;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _fetchHistory();

    searchController.addListener(() {
      if(_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        SearchStudent(searchController.text);
      });
    });
  }

  void handleSearchTapped() async{
    isSearching.value = !isSearching.value;
    if(isSearching.value == false){
      searchController.text = '';
      isLoading.value = true;
      // await _fetchStudentDetails();
    }
  }

  Future<void> _fetchHistory() async {
    if(isEventAttendance){
      final eventAttendanceHistory = await _eventController.fetchEventAttendanceForToday(null);
      studentHistoryDetails.value = eventAttendanceHistory;
      isLoading.value = false;
    } else if (isBooklet){
      final bookletHistory = await _bookletController.fetchBookletsClaimedToday();
      studentHistoryDetails.value = bookletHistory;
      isLoading.value = false;
    }
    else {
      final borrowHistory = await _borrowController.fetchBorrowHistory();
      studentHistoryDetails.value = borrowHistory;
      isLoading.value = false;
    }
  }

  Future<void> SearchStudent(String query) async {
    debugPrint('$query');
    if (query.isEmpty) {
      // If the query is empty, fetch all students
      // await _fetchStudentDetails();
      return;
    }

    try {
      isLoading.value = true;
      // final students = await _service.searchStudent(query);
      // debugPrint('$students');
      // studentDetails.clear();
      // studentDetails.addAll(students);
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error searching students: $e');
    } 
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if(_picked != null){
      dateController.text = _picked.toString().split(' ')[0];
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



  Widget handleSearchBar() {
    return isSearching.value
        ? Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true, // Enable the background fill
                    fillColor: Colors.white, // Set the background color to white
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.HISTORYICONCOLOR,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.HISTORYICONCOLOR,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.HISTORYICONCOLOR,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3)
                  ),
                ),
              ),
              const SizedBox(width: 10), // Add some spacing between the TextField and the cancel icon
              InkWell(
                onTap: handleSearchTapped,
                child: SvgPicture.asset(
                  AppIcons.CANCELICON,
                  color: AppColors.HISTORYICONCOLOR,
                  width: 35,
                  height: 35,
                ),
              ),
            ],
          )
        : InkWell(
            onTap: handleSearchTapped,
            child: SvgPicture.asset(
              AppIcons.SEARCHICON,
              color: AppColors.HISTORYICONCOLOR,
              width: 35,
              height: 35,
            ),
          );
  }
// void showCalendarDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select a Date'),
//         content: SizedBox(
//             width: 300,  // You can adjust the width
//             height: 300, // You can adjust the height
//             child: TableCalendar(
//               focusedDay: DateTime.now(),
//               firstDay: DateTime.utc(2020, 01, 01),
//               lastDay: DateTime.utc(2100, 12, 31),
//               onDaySelected: (selectedDay, focusedDay) {
//                 Navigator.of(context).pop(selectedDay);
//               },
//             ),
//           ),
        
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('DONE'),
//           ),
//         ],
//       );
//     },
//   ).then((selectedDate) {
//     if (selectedDate != null) {
//       // Handle the selected date here, e.g., update a Text widget
//       debugPrint('Selected date: $selectedDate');
//     }
//   });
// }



  @override
  void onClose(){
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
