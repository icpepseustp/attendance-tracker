import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanController extends BaseController {
  ScanController(this._service);

  final FirestoreService _service;
  var borrowStatus = false.obs;
  var isScanning = true.obs;
  var overlaySize = 0.7.obs;
  var isTorchEnabled = false.obs;
  final MobileScannerController mobileScannerController = MobileScannerController();

  String getTorchIcon(){
    return isTorchEnabled.value? AppIcons.TORCHONICON : AppIcons.TORCHOFFICON;
  }

  void toggleTorch(){
    debugPrint('Torch clicked');
    mobileScannerController.toggleTorch();
    isTorchEnabled.value = !isTorchEnabled.value;
  }

  void stopScanning() {
    isScanning.value = false; // Set to false to stop scanning
  }

  void startScanning() {
    isScanning.value = true; // Set to true to start scanning
  }

  void handleDisplaySizeChange(double value){
    overlaySize.value = value;
  }

  void handleQrCode(BuildContext context, String code) async {

    // Split the QR code by spaces
    List<String> stringParts = code.split(RegExp(r'\s+'));
    
    if(stringParts.length < 3) {
      debugPrint('Invalid QR code content: $code');
      startScanning();  
      return;
    }

    String name = stringParts.sublist(1, stringParts.length - 3).join(' ');
    String idNumber = stringParts.last;
    final bool isBorrowing = BaseController.selectedUsage.value.description == AppStrings.BORROWCOMPONENTS ? true : false;  
    await _editStudent(name, idNumber, isBorrowing);
    
    showDialog(
      context: context,
      barrierDismissible: true, // Allows the user to dismiss the dialog by tapping outside of it
      builder: (context) {
        // Set up a listener for when the dialog is dismissed
        return WillPopScope(
          onWillPop: () async {
            // This will be triggered when the dialog is dismissed by tapping outside
            await Future.delayed(const Duration(milliseconds: 500));
            return true; // Allow the pop (dismissal)
          },
          child: AlertDialog(
            backgroundColor: AppColors.BGCOLOR,
            title: Text(
              BaseController.selectedEvent.value.description,
              style: AppTextStyles.qrDetectedDialog,
            ),
            content: Text(
              'Name: $name \nID Number: $idNumber',
              style: AppTextStyles.qrDetectedDialog
              ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await Future.delayed(const Duration(milliseconds: 500));
                  startScanning(); // Resume scanning after the dialog is closed
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    ).then((_) async {
      // This will be called when the dialog is dismissed (either by pressing OK or tapping outside)
      await Future.delayed(const Duration(milliseconds: 500));
      startScanning(); // Resume scanning after the dialog is dismissed
    });
  }
  

  Future<void> onQrDetect(BuildContext context, BarcodeCapture capture) async {
    if (isScanning.value) {
      // Pause scanning
      stopScanning();

      final List<Barcode> barcodes = capture.barcodes;
      final Barcode firstBarcode = barcodes.first;
      if (firstBarcode.rawValue != null) {
        final String code = firstBarcode.rawValue!;
        debugPrint('code: $code');
        handleQrCode(context, code);
      }
    }
  }

  Future<void> _editStudent(String name, String idNumber, bool isBorrowing) async {
    if(isBorrowing){
      borrowStatus.value = !borrowStatus.value;  
    }

    final Map<String, dynamic> studentData = {
      AppStrings.STUDENT_NAME: name,
      AppStrings.STUDENT_ID: idNumber,
      AppStrings.BORROWSTATUS: isBorrowing
    };

    final Map<String, dynamic> attendanceData = {
      AppStrings.DATE: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      AppStrings.TIME: DateFormat('HH:mm:ss').format(DateTime.now()),
      AppStrings.EVENTID: BaseController.selectedEvent.value.id
    };

    final Map<String, dynamic> updateData = {
      AppStrings.BORROWSTATUS: borrowStatus.value
    };

    
    try {
      await _service.createStudent(studentData, attendanceData, updateData);
      debugPrint('Attendance recorded');
    } catch (e) {
      debugPrint('Error adding attendance record: $e');
      showSnackBar('Error', 'Failed to add attendance record', Colors.red);
    }
  }


  


}