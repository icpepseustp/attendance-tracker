import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends GetxService {
  final dbFirestore = FirebaseFirestore.instance;

  Future<DocumentReference> _create(String collectionPath, Map<String, dynamic> data) async {
    return await dbFirestore.collection(collectionPath).add(data);
  }
  
}