import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BorrowController extends BaseController {
  
  BorrowController(this._service);

  final FirestoreService _service;

  // initialize the borrow status of the 
  var borrowStatus = true.obs;

  final TextEditingController inputComponentController = TextEditingController();

  // get the borrow status of the current student
  Future<bool> getCurrentBorrowStatus(String studentId) async {
    try {
      final studentDoc = await _service.getStudentById(studentId);

      if (studentDoc!.exists) {
      // Extract the borrow status from the document
      // Assuming the borrow status field is a boolean
      final borrowStatus = studentDoc[AppStrings.BORROWSTATUS] as bool;
      // Return the borrow status
      return borrowStatus;
    } else {
      // Handle case where student document is not found
      debugPrint('Student document not found for ID: $studentId');
      return false; // Default value when student document is not found
    }
    } catch (e) {
      debugPrint('Error fetching current borrow status: $e');
      return false;
    }
  }

  // record everytime the student borrows or returns a component  
  Future<void> recordBorrowComponent(String name, String studentId) async {
    final now = DateTime.now();
    final componentName = inputComponentController.text.trim();
    
    borrowStatus.value = !borrowStatus.value;

    final studentData = {
      AppStrings.STUDENT_NAME: name,
      AppStrings.STUDENT_ID: studentId,
      AppStrings.BORROWSTATUS: isBorrowing,
    };

    final borrowStatusData = {
      AppStrings.BORROWSTATUS: borrowStatus.value
    };

    final borrowDetailsData = {
      AppStrings.DATE: formatDate(now),
      AppStrings.TIME: formatTime(now),
      AppStrings.DATERETURNED: '',
      AppStrings.TIMERETURNED: '',
      AppStrings.COMPONENTNAME: componentName
    };

    // if the borrow status is false, that means the student has returned a component
    // thus, we will fill up the date returned and time returned
    if(!borrowStatus.value){
      borrowDetailsData[AppStrings.DATERETURNED] = formatDate(now);
      borrowDetailsData[AppStrings.TIMERETURNED] = formatTime(now);
    }
    
    try {
      // update the borrow status of the student
      await _service.updateStudentField(studentId, borrowStatusData);

      final docRef = await _service.getOrCreateDocumentId(studentData, studentId);

      final subDocs = await _service.getSubDoc(docRef.id, AppStrings.BORROWDETAILS, AppStrings.DATERETURNED, '');
      
      // if the date returned and time returned is not empty, we will simply update the subdocs
      if (subDocs.docs.isNotEmpty) {
        await subDocs.docs.first.reference.update({
          AppStrings.DATERETURNED: borrowDetailsData[AppStrings.DATERETURNED],
          AppStrings.TIMERETURNED: borrowDetailsData[AppStrings.TIMERETURNED],
      });
      } else {
        // if the subdocs are emtpy, we will create new subdocs for the student
        await _service.createSubDoc(borrowDetailsData, docRef.id, AppStrings.BORROWDETAILS);
      }
    } catch (e) {
      debugPrint('ERror recording borrow component: $e');
    }
  }

  Column borrowAlertDialog(String name, String studentId) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Name: $name \nID Number: $studentId', 
          style: AppTextStyles.QRDETECTEDDIALOG
        ),
         if (!borrowStatus.value)
          TextField(
            controller: inputComponentController,
            decoration: InputDecoration(
              labelText: 'Input component',
            ),
          ),
      ],
    );
  }

  @override
  void onClose(){
    inputComponentController.dispose();
    super.onClose();
  }

}