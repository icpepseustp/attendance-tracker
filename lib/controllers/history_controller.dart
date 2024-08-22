import 'dart:async';

import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends BaseController {
  HistoryController(this._service);

  final FirestoreService _service;

  var isLoading = true.obs;

  var isSearching = false.obs;

  final RxList<StudentDetailsModel> studentDetails = <StudentDetailsModel>[].obs;
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _fetchAttendanceForToday();

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
      isLoading.value = true;
      await _fetchAttendanceForToday();
    }
  }

  Future<void> SearchStudent(String query) async {
    debugPrint('$query');
    if (query.isEmpty) {
      // If the query is empty, fetch all students
      await _fetchAttendanceForToday();
      return;
    }

    try {
      final students = await _service.searchStudent(query);
      debugPrint('$students');
      studentDetails.clear();

      for (var student in students){
        String studentId = student['ID_number'];
         
        List<Map<String, dynamic>> attendance = await _service.getAttendanceForStudent(studentId);

        for (var record in attendance){
          studentDetails.add(StudentDetailsModel(
          studentName: student['name'], 
          studentId: student['ID_number'], 
          date: DateFormat('M/d/yyyy').format(DateTime.parse(record['date'])),
          time: DateFormat('h:mm a').format(DateTime.parse(record['date']))));
        }
      }
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error searching students: $e');
    }
  }

  Future<void> _fetchAttendanceForToday() async {
    try {
      final students = await _service.getAllStudents();
      studentDetails.clear();

      for (var student in students) {
        String studentId = student['ID_number'];

        List<Map<String, dynamic>> attendance =
            await _service.getAttendanceForStudent(studentId);

        for (var record in attendance) {
          studentDetails.add(StudentDetailsModel(
              studentName: student['name'],
              studentId: student['ID_number'],
              date: DateFormat('M/d/yyyy').format(DateTime.parse(record['date'])),
              time: DateFormat('h:mm a').format(DateTime.parse(record['date']))));
        }
        isLoading.value = false;

      }
    } catch (e) {
      debugPrint('Error fetching attendance data: $e');
    }
  }

  Widget handleHistoryDisplay() {
    return isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: studentDetails.map((student) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Add bottom padding for spacing
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QrWidget(
                        data:
                            '${student.studentName} - ${student.studentId}'), // Add a QR code widget for each student
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${student.studentName} - ${student.studentId}',
                            style: AppTextStyles.studentDetails,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${student.date} \t ${student.time}', // Replace with actual date and time fields if available
                            style: AppTextStyles.DateAndTime,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
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

}
