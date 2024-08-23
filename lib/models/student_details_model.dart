import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailsModel {
  StudentDetailsModel({
    required this.studentName,
    required this.studentId,
    required this.attendanceDate,
    required this.attendanceTime,
  });

  final String studentName;
  final String studentId;
  final String attendanceDate;
  final String attendanceTime;

  factory StudentDetailsModel.fromSnapshot(DocumentSnapshot mainCollection, DocumentSnapshot subCollection) {
    // final mainCollData = mainCollection.data() as Map<String, dynamic>;
    final subCollData = subCollection.data() as Map<String, dynamic>;

    final dateString = subCollData[AppStrings.DATE];
    final timeString = subCollData[AppStrings.TIME];

    final dateTimeString = DateTime.parse('$dateString $timeString');

    return StudentDetailsModel(
      studentName: mainCollection[AppStrings.STUDENT_NAME],
      studentId: mainCollection[AppStrings.STUDENT_ID],
      attendanceDate: DateFormat('M/d/yyyy').format(dateTimeString),
      attendanceTime: DateFormat('h:mm a').format(dateTimeString),
    );
  }

  Map<String, dynamic> toMap() => {
    AppStrings.STUDENT_NAME: studentName,
    AppStrings.STUDENT_ID: studentId,
    AppStrings.DATE: attendanceDate,
    AppStrings.TIME: attendanceTime
  };

  @override
  String toString() {
    return 'StudentDetailsModel(studentName: $studentName, studentId: $studentId, date: $attendanceDate, time: $attendanceTime)';
  }
}
