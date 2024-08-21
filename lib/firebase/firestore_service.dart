import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService extends GetxService {
  final dbFirestore = FirebaseFirestore.instance;

  Future<DocumentReference> _create(String collectionPath, Map<String, dynamic> data) async {
    return await dbFirestore.collection(collectionPath).add(data);
  }

  Future<DocumentReference> createAttendance(Map<String, dynamic> data) async {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _create(currentDate, data);
  } 
  
}