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

  Future<DocumentReference> _createDoc(Map<String, dynamic> docData) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).add(docData);
  }

  Future<DocumentReference> _createSubDoc(Map<String, dynamic> subDocData, String docId, String collectionPath) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).doc(docId).collection(collectionPath).add(subDocData);
  }

  Future<void> createStudent(
    Map<String, dynamic> data, 
    Map<String, dynamic> subData, 
    Map<String, dynamic> updateData, 
    Map<String, dynamic> updateDetails
  ) async {
    try {
      final existingDocs = await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
          .where(AppStrings.STUDENT_ID, isEqualTo: data[AppStrings.STUDENT_ID])
          .limit(1)
          .get();

      String docId;
      if (existingDocs.docs.isNotEmpty) {
        docId = existingDocs.docs.first.id;

        if (BaseController.selectedUsage.value.description == AppStrings.BOOKLET) {
          final remainingBooklet = existingDocs.docs.first.get(AppStrings.CLAIMABLEBOOKLET);
          if (remainingBooklet > 0) {
            await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).doc(docId)
              .update({AppStrings.CLAIMABLEBOOKLET: remainingBooklet - 1});
          }
        }
      } else {
        data[AppStrings.CLAIMABLEBOOKLET] = 4;
        final docRef = await _createDoc(data);
        docId = docRef.id;
      }

      switch (BaseController.selectedUsage.value.description) {
        case AppStrings.EVENTATTENDANCE:
          await _createSubDoc(subData, docId, AppStrings.ATTENDANCECOLLECTION);
          break;
        case AppStrings.BORROWCOMPONENTS:
          await _editBorrowComponent(docId, updateData, updateDetails);
          break;
      }
    } catch (e) {
      debugPrint('Error creating student attendance: $e');
    }
  }

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

  Future<QuerySnapshot<Map<String, dynamic>>> _getSubDoc(String id) async {
    return await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
        .doc(id)
        .collection(AppStrings.ATTENDANCECOLLECTION)
        .where(AppStrings.DATE, isEqualTo: today)
        .get();
  }

  Future<List<StudentDetailsModel>> getAttendanceForToday(String? query) async {
    try {
      final mainDocs = await _getMainDoc(query, AppStrings.STUDENTSCOLLECTION);
      List<StudentDetailsModel> attendanceList = [];

      await Future.wait(mainDocs.docs.map((mainDoc) async {
        final subDocs = await _getSubDoc(mainDoc.id);
        attendanceList.addAll(subDocs.docs.map((subDoc) => StudentDetailsModel.fromSnapshot(mainDoc, subDoc)));
      }));

      return attendanceList;
    } catch (e) {
      debugPrint('Error fetching attendance data: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      final querySnapshot = await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
          .where(AppStrings.STUDENT_ID, isEqualTo: studentId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching student by ID: $e');
      return null;
    }
  }

  Future<List<StudentDetailsModel>> searchStudent(String query) async {
    return query.isEmpty ? [] : await getAttendanceForToday(query);
  }

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

  Future<void> _editBorrowComponent(String docId, Map<String, dynamic> updateData, Map<String, dynamic> updateDetails) async {
    try {
      await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION).doc(docId).update(updateData);

      final subDocs = await _dbFirestore.collection(AppStrings.STUDENTSCOLLECTION)
          .doc(docId)
          .collection(AppStrings.BORROWDETAILS)
          .where(AppStrings.DATERETURNED, isEqualTo: '')
          .limit(1)
          .get();

      if (subDocs.docs.isNotEmpty) {
        await subDocs.docs.first.reference.update({
          AppStrings.DATERETURNED: BaseController().getCurrentDate(),
          AppStrings.TIMERETURNED: BaseController().getCurrentTime(),
        });
      } else {
        await _createSubDoc(updateDetails, docId, AppStrings.BORROWDETAILS);
      }
    } catch (e) {
      debugPrint('Error updating borrow component: $e');
    }
  }
}
