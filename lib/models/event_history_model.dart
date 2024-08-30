import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventHistoryModel extends HistoryModel{
  
  @override
  final String studentName;

  @override
  final String studentId;
  final String attendanceDate;
  final String attendanceTime;

  EventHistoryModel({
    required this.studentName,
    required this.studentId,
    required this.attendanceDate,
    required this.attendanceTime,
  });

  factory EventHistoryModel.fromSnapshot(DocumentSnapshot mainCollection, DocumentSnapshot subCollection) {
    // final mainCollData = mainCollection.data() as Map<String, dynamic>;
    // final subCollData = subCollection.data() as Map<String, dynamic>;

    // final dateString = subCollData[AppStrings.DATE];
    // final timeString = subCollData[AppStrings.TIME];

    // final dateTimeString = DateTime.parse('$dateString $timeString');

    return EventHistoryModel(
      studentName: mainCollection[AppStrings.STUDENT_NAME],
      studentId: mainCollection[AppStrings.STUDENT_ID],
      attendanceDate: subCollection[AppStrings.DATE],
      attendanceTime: subCollection[AppStrings.TIME],
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
    return 'EventHistoryModel(studentName: $studentName, studentId: $studentId, date: $attendanceDate, time: $attendanceTime)';
  }
}
