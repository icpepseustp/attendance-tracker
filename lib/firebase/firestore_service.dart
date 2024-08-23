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
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).add(docData); 
  }

  Future<DocumentReference> _createSubDoc(Map<String, dynamic> subDocData, String docId) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).doc(docId).collection(AppStrings.ATTENDANCECOLLECTION).add(subDocData);
  }

  // create a new student attendance
  Future<void> createStudentAttendance(Map<String, dynamic> data, Map<String, dynamic> subData) async {
    final docRef = await _createDoc(data);
    await _createSubDoc(subData, docRef.id);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getMainDoc(String? query, String studentDbCollection) async {
    if(query != null){
      return await _dbFirestore.collection(studentDbCollection)
      .orderBy('studentName')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .get();
    }else {
      return await _dbFirestore.collection(studentDbCollection).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getSubDoc(String uid)async{
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
      .doc(uid)
      .collection(AppStrings.ATTENDANCECOLLECTION)
      .where('attendanceDate', isEqualTo: today)
      .get();
  }


// Get attendance for today
Future<List<StudentDetailsModel>> getAttendanceForToday(String? query) async {
  try {

    final QuerySnapshot<Map<String, dynamic>> mainDocs = await _getMainDoc(query, AppStrings.STUDENTSCOLLECTION);

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

  Future<List<StudentDetailsModel>> searchStudent(String query) async {
    if(query.isEmpty){
      return [];
    }
    return await getAttendanceForToday(query);
  }

  Future<List<Map<dynamic, dynamic>>> getEvents() async {
    try {
      final eventsSnapshot = await _getMainDoc(null, AppStrings.EVENTSCOLLECTION);
      
      List<Map<dynamic, dynamic>> eventDescriptions = eventsSnapshot.docs.map((doc) {
        final eventDescription = doc.data()['eventDescription'];
        final eventId = doc.data()['eventId'];

        return {eventDescription: eventId};

      }).toList();

      return eventDescriptions;
    } catch (e) {
      print('Error fetching event descriptions: $e');
      return [];
    }
  }
  
  
}