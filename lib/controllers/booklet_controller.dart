import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookletController extends BaseController {

  // constrcutor for the firesore service
  BookletController(this._service);

  // initialize the firestore service
  final FirestoreService _service;

  // initialize the booklet count that the student can claim
  var bookletCount = 0.obs;

  // decrement the booklet COunt
  void decrementBookletCount() {
    bookletCount.value > 0 ? bookletCount.value-- : null;
  }

  // increment the booklet count
  void incrementBookletCount(){
    bookletCount.value < 4 ? bookletCount.value++ : null;
  }

  // fetch how many booklets the student can still claim
  Future<String> fetchClaimableBooklets(String studentId) async {
    try {
      final studentData = await _service.getStudentById(studentId);
      return studentData![AppStrings.CLAIMABLEBOOKLET]?.toString() ?? '4';  
    } catch (e) {
      debugPrint('Error fetching remaining booklets: $e');
      // return 4 booklets if there is no existing data (starting amount of booklets for each student is 4)
      return '4';
    }
  }

  // record everytime a student claims a booklet
  Future<void> recordClaimableBooklets(String studentId, String name) async {
    if(!isBooklet) return;

    try {
      final studentDoc = await _service.getStudentById(studentId);

      if (studentDoc != null && studentDoc.exists) {
        // Document exists, update the claimable booklets
        int currentBookletCount = studentDoc[AppStrings.CLAIMABLEBOOKLET] ?? 0;

        int newBookletCount = currentBookletCount - bookletCount.value;

        // Ensure booklet count doesn't go below zero
        newBookletCount = newBookletCount < 0 ? 0 : newBookletCount;

        await _service.updateStudentField(studentId, {AppStrings.CLAIMABLEBOOKLET: newBookletCount});
      } else {
        // Document does not exist, create a new one
        final studentData = {
          AppStrings.STUDENT_NAME: name,
          AppStrings.STUDENT_ID: studentId,
          AppStrings.BORROWSTATUS: isBorrowing,
          AppStrings.CLAIMABLEBOOKLET: 4 - bookletCount.value
        };

        await _service.createDoc(studentData);
      }
    } catch (e) {
      debugPrint('Error updating claimable booklets: $e');
    }
  }

  // the alert dialog for the booklet controller
  Column bookletAlertDialog(String name, String studentId){
    return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Name: $name \nID Number: $studentId', 
            style: AppTextStyles.QRDETECTEDDIALOG
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Claim:',
                style: AppTextStyles.QRDETECTEDDIALOG,
              ),
              IconButton(
                onPressed: decrementBookletCount, 
                icon: const Icon(Icons.remove, color: AppColors.NAVBARCOLOR),
              ),
              Obx(
                () => Text(
                bookletCount.value.toString(),
                style: AppTextStyles.QRDETECTEDDIALOG,
              )
              ),
              IconButton(
                onPressed: incrementBookletCount, 
                icon: const Icon(Icons.add, color: AppColors.NAVBARCOLOR)
              )
            ],
          ),
        ],
      );
  }
  
}