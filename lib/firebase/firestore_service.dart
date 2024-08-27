import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService extends GetxService {
  final _dbFirestore = FirebaseFirestore.instance;
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<DocumentReference> createDoc(Map<String, dynamic> docData) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).add(docData);
  }

  Future<DocumentReference> createSubDoc(Map<String, dynamic> subDocData, String docId, String collectionPath) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).doc(docId).collection(collectionPath).add(subDocData);
  }

  
  // if the document exists, get the id, if it doesnt, create a new document and get the id
  Future<DocumentSnapshot> getOrCreateDocumentId(Map<String, dynamic> data, String studentId) async {
  try {
    final existingDocs = await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
          .where(AppStrings.STUDENT_ID, isEqualTo: studentId)
          .limit(1)
          .get();

    if (existingDocs.docs.isNotEmpty) {
      // Document exists, get the document ID
      return existingDocs.docs.first;
    } else {
      // Document does not exist, create a new document
      data[AppStrings.CLAIMABLEBOOKLET] = 4; 
      final docRef = await createDoc(data); 
      
      return await docRef.get();
    } 
  } catch (e) {
    debugPrint('Error getting or creating document ID: $e');
    rethrow;
  }
}

  // get the main collection
  Future<QuerySnapshot<Map<String, dynamic>>> _getMainDoc(String? query, String studentDbCollection) async {
    final collectionRef = _dbFirestore.collection(studentDbCollection);
    if (query != null) {
      return await collectionRef.orderBy(AppStrings.STUDENT_NAME)
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();
    } else {
      return await collectionRef.get();
    }
  }

  // get the sub collection
  Future<QuerySnapshot<Map<String, dynamic>>> getSubDoc(String id, String collectionPath, String fieldName, String equalToPath) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
        .doc(id)
        .collection(collectionPath)
        .where(fieldName, isEqualTo: equalToPath)
        .get();
  }

  // Future<List<StudentDetailsModel>> getAttendanceForToday(String? query) async {
  //   try {
  //     final mainDocs = await _getMainDoc(query, AppStrings.STUDENTSCOLLECTION);
  //     List<StudentDetailsModel> attendanceList = [];

  //     await Future.wait(mainDocs.docs.map((mainDoc) async {
  //       final subDocs = await _getSubDoc(mainDoc.id);
  //       attendanceList.addAll(subDocs.docs.map((subDoc) => StudentDetailsModel.fromSnapshot(mainDoc, subDoc)));
  //     }));

  //     return attendanceList;
  //   } catch (e) {
  //     debugPrint('Error fetching attendance data: $e');
  //     return [];
  //   }
  // }


  // Future<List<StudentDetailsModel>> searchStudent(String query) async {
  //   return query.isEmpty ? [] : await getAttendanceForToday(query);
  // }

  Future<List<Map<dynamic, dynamic>>> getEvents() async {
    try {
      final eventsSnapshot = await _getMainDoc(null, AppStrings.EVENTSCOLLECTION);
      return eventsSnapshot.docs.map((doc) {
        return {
          doc.get(AppStrings.EVENTDESCRIPTION): doc.get(AppStrings.EVENTID),
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching event descriptions: $e');
      return [];
    }
  }

  Future<DocumentSnapshot?> getStudentById(String studentId) async {
    try {
      final querySnapshot = await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
          .where(AppStrings.STUDENT_ID, isEqualTo: studentId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching student by ID: $e');
      return null;
    }
  }


  // update the student document based on given data
  Future<void> updateStudentField(String studentId, Map<String, dynamic> data) async{
    try {
      final docSnapshot = await getStudentById(studentId);

      await docSnapshot!.reference.update(data);
      
    } catch (e) {
      debugPrint('Error updating student field: $e');
    }
  }
}
