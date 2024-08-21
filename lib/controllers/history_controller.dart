import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends BaseController {
  HistoryController(this._service);

  final FirestoreService _service;

  var isLoading = true.obs;
  
  final RxList<StudentDetailsModel> studentDetails = <StudentDetailsModel>[].obs; 

  @override
  Future<void> onInit()async {
    super.onInit();
    await _fetchAttendanceForToday();
    isLoading.value = false;
  }

  Future<void> _fetchAttendanceForToday() async {
    try {
      final students = await _service.getAllStudents();
      studentDetails.clear();

      for (var student in students){
        String  studentId = student['ID_number'];

        List<Map<String, dynamic>> attendance = await _service.getAttendanceForStudent(studentId);
        
        for(var record in attendance){
          studentDetails.add(StudentDetailsModel(
            studentName: student['name'], 
            studentId: student['ID_number'], 
            date: DateFormat('M/d/yyyy').format(DateTime.parse(record['date'])), 
            time: DateFormat('h:mm a').format(DateTime.parse(record['date']))
          ));
        }

        debugPrint('$student');
      }
    } catch (e) {
      debugPrint('Error fetching attendance data: $e');
    }
  }

  Widget handleHistoryDisplay() {
    return isLoading.value
      ? const Center(child: CircularProgressIndicator())
      :  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: studentDetails.map((student) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: 10.0), // Add bottom padding for spacing
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrWidget(data: '${student.studentName} - ${student.studentId}'), // Add a QR code widget for each student
              const SizedBox(width: 10),
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

  // final List<StudentDetailsModel> studentDetails = [
  //   StudentDetailsModel(
  //     studentName: 'Robert Roy P. Salvo',
  //     studentId: 2022300157,
  //     date: '8/20/2024',
  //     time: '8:40 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Ceirik Agustin',
  //     studentId: 2023402482,
  //     date: '8/20/2024',
  //     time: '8:45 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Anna Maria Lopez',
  //     studentId: 2024101987,
  //     date: '8/21/2024',
  //     time: '9:00 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Juan Carlos Mendoza',
  //     studentId: 2024501988,
  //     date: '8/21/2024',
  //     time: '9:15 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Maria Clara Reyes',
  //     studentId: 2025103456,
  //     date: '8/22/2024',
  //     time: '10:00 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Carlos Alberto Garcia',
  //     studentId: 2025307890,
  //     date: '8/22/2024',
  //     time: '10:15 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Isabella Fernandez',
  //     studentId: 2025401234,
  //     date: '8/23/2024',
  //     time: '11:00 AM',
  //   ),
  //   StudentDetailsModel(
  //     studentName: 'Sebastian Silva',
  //     studentId: 2025505678,
  //     date: '8/23/2024',
  //     time: '11:30 AM',
  //   ),
  // ];
}
