import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService extends GetxService {
  final _dbFirestore = FirebaseFirestore.instance;
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // create a new student attendance
  Future<void> createStudentAttendance(String studentId, Map<String, dynamic> studentData, Map<String, dynamic> attendanceData) async {
    final DocumentReference studentRef = _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).doc();

    await _dbFirestore.runTransaction((transaction) async {
      // set student data
      transaction.set(studentRef, studentData);

      // add the attendance record to student's subcollection
      final attendanceRef = studentRef.collection(AppStrings.SUBDBCOLLECTION).doc();
      transaction.set(attendanceRef, attendanceData);
    }).catchError((e) {
      debugPrint('Error during transaction: $e');
      throw e;
    });
  }

  // Get attendance for today
  Future<List<StudentDetailsModel>> getAttendanceForToday(QuerySnapshot? snapshot) async {
    
    snapshot ??= await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).get();
    
    try {
      
      List<StudentDetailsModel> attendanceList = [];

      // Use Future.wait to fetch all subcollections in parallel
      final futures = snapshot.docs.map((doc) async {
        final subCollection = await doc.reference.collection(AppStrings.SUBDBCOLLECTION)
          .where('Date', isEqualTo: today)
          .get();
        
        final studentDetails = subCollection.docs.map((subDoc) {
          return StudentDetailsModel.fromSnapshot(doc, subDoc);
        });

        attendanceList.addAll(studentDetails);
      });

      await Future.wait(futures);
      return attendanceList;
    } catch (e) {
      debugPrint('Error fetching attendance data: $e');
      return [];
    }
  }

  // // Get all students
  // Future<List<Map<String, dynamic>>> getAllStudents() async {
  //   QuerySnapshot snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).get();
  //   return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  // }


  Future<List<StudentDetailsModel>> searchStudent(String query) async {
    if(query.isEmpty){
      return [];
    }

    final snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION)
      .orderBy('Name')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .get();

    return await getAttendanceForToday(snapshot);
  }

  
  
}