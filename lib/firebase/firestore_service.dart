import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService extends GetxService {
  final _dbFirestore = FirebaseFirestore.instance;
  

  // create a new student attendance
  Future<void> createStudentAttendance(String studentId, Map<String, dynamic> studentData, Map<String, dynamic> attendanceData) async {
    final DocumentReference studentRef = _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).doc(studentId);

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
  
  // get the attendance record for a specific student
  Future<List<Map<String, dynamic>>> getAttendanceForStudent(String studentId) async {
    QuerySnapshot snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).doc(studentId).collection(AppStrings.SUBDBCOLLECTION).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Get all students
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    QuerySnapshot snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // get attendance record for today
  Future<List<Map<String, dynamic>>> getAttendanceForToday() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    QuerySnapshot snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION)
      .where('date', isEqualTo: today)
      .get();
    
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> searchStudent(String query) async {
    if(query.isEmpty){
      return [];
    }

    QuerySnapshot snapshot = await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION)
      .orderBy('name')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .get();
    

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  
  
}