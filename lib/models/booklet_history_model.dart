import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookletHistoryModel extends HistoryModel{
  
  @override
  final String studentName;
  
  @override
  final String studentId;
  final int booklets;
  final String time;
  

  BookletHistoryModel({
    required this.studentId,
    required this.studentName,
    required this.booklets,
    required this.time
  });

  factory BookletHistoryModel.fromSnapshot(DocumentSnapshot mainCollection, DocumentSnapshot subCollection) {

    return BookletHistoryModel(
      studentId: mainCollection[AppStrings.STUDENT_ID], 
      studentName: mainCollection[AppStrings.STUDENT_NAME],
      booklets: subCollection[AppStrings.CLAIMEDBOOKLETS],
      time: subCollection[AppStrings.TIME]
    );
  }

  Map<String, dynamic> toMap() => {
    AppStrings.STUDENT_NAME: studentName,
    AppStrings.STUDENT_ID: studentId,
    AppStrings.BOOKLET: booklets,
    AppStrings.TIME: time
  };

  @override
  String toString() {
    return 'BookletHistoryModel(studentName: $studentName, studentId: $studentId, claimed: $booklets)';
  }
  

}