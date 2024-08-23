import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService extends GetxService {
  final _dbFirestore = FirebaseFirestore.instance;
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<DocumentReference> _createDoc(Map<String, dynamic> docData) async {
    return await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).add(docData); 
  }

  Future<DocumentReference> _createSubDoc(Map<String, dynamic> subDocData) async {
    return await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).doc().collection(AppStrings.SUBDBCOLLECTION).add(subDocData);
  }

  // create a new student attendance
  Future<void> createStudentAttendance(Map<String, dynamic> data, Map<String, dynamic> subData) async {
    await _createDoc(data);
    await _createSubDoc(subData);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getMainDoc(String? query) async {
    if(query != null){
      return await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION)
      .orderBy('Name')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .get();
    }else {
      return await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getSubDoc(String uid)async{
    return await _dbFirestore.collection(AppStrings.MAINDBCOLLECTION)
      .doc(uid)
      .collection(AppStrings.SUBDBCOLLECTION)
      .where('Date', isEqualTo: today)
      .get();
  }


// Get attendance for today
Future<List<StudentDetailsModel>> getAttendanceForToday(String? query) async {
  try {

    final QuerySnapshot<Map<String, dynamic>> mainDocs = await _getMainDoc(query);

    List<StudentDetailsModel> attendanceList = [];

    final futures = mainDocs.docs.map((mainDoc) async {
      final QuerySnapshot<Map<String, dynamic>> subDocs = await _getSubDoc(mainDoc.id);

      for (var subDoc in subDocs.docs) {
        final studentDetails = StudentDetailsModel.fromSnapshot(mainDoc, subDoc);
        attendanceList.add(studentDetails);
      }
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

    return await getAttendanceForToday(query);
  }

  
  
}