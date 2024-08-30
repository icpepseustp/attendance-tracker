import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowHistoryModel extends HistoryModel {
  @override
  final String studentName;

  @override
  final String studentId;
  final String date;
  final String componentBorrowed;
  final String dateReturned;

  BorrowHistoryModel({
    required this.studentName,
    required this.studentId,
    required this.date,
    required this.componentBorrowed,
    required this.dateReturned
  });

  factory BorrowHistoryModel.fromSnapshot(DocumentSnapshot mainCollection, DocumentSnapshot subCollection) {
    
    return BorrowHistoryModel(
      studentName: mainCollection[AppStrings.STUDENT_NAME], 
      studentId: mainCollection[AppStrings.STUDENT_ID], 
      date: subCollection[AppStrings.DATE], 
      componentBorrowed: subCollection[AppStrings.COMPONENTNAME],
      dateReturned: subCollection[AppStrings.DATERETURNED]
    );
  }

  Map<String, dynamic> toMap() => {
    AppStrings.STUDENT_NAME: studentName,
    AppStrings.STUDENT_ID: studentId,
    AppStrings.DATE: date,
    AppStrings.COMPONENTNAME: componentBorrowed,
    AppStrings.DATERETURNED: dateReturned
  };

  @override
  String toString() {
    return 'BorrowHistoryModel(studentName: $studentName, studentId: $studentId, borrowedComponent: $componentBorrowed)';
  }



}