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
  final selectedEventDescription = BaseController.selectedEvent.value.description;
  final selectedUsageDescription = BaseController.selectedUsage.value.description;

  var borrowStatus = true.obs;
  var isScanning = true.obs;
  var overlaySize = 0.7.obs;
  var isTorchEnabled = false.obs;
  final MobileScannerController mobileScannerController = MobileScannerController();

  String getTorchIcon() => isTorchEnabled.value ? AppIcons.TORCHONICON : AppIcons.TORCHOFFICON;

  void toggleTorch() {
    debugPrint('Torch clicked');
    mobileScannerController.toggleTorch();
    isTorchEnabled.value = !isTorchEnabled.value;
  }

  void stopScanning() => isScanning.value = false;

  void startScanning() => isScanning.value = true;

  void handleDisplaySizeChange(double value) => overlaySize.value = value;

  void handleQrCode(BuildContext context, String code) async {
    final stringParts = code.split(RegExp(r'\s+'));
    
    if (stringParts.length < 3) {
      debugPrint('Invalid QR code content: $code');
      startScanning();
      return;
    }

    final name = stringParts.sublist(1, stringParts.length - 3).join(' ');
    final studentId = stringParts.last;
    final isBorrowing = selectedUsageDescription == AppStrings.BORROWCOMPONENTS;

    await _editStudent(name, studentId, isBorrowing);

    if (selectedUsageDescription == AppStrings.EVENTATTENDANCE) {
      _showQrDialog(context, name, studentId, null, selectedEventDescription);
    } else if (selectedUsageDescription == AppStrings.BOOKLET) {
      final claimableBooklets = await _fetchClaimableBooklets(studentId);
      final message = claimableBooklets == '0'
          ? 'No more booklets left'
          : 'Claimable Booklets: $claimableBooklets';
      _showQrDialog(context, name, studentId, claimableBooklets, message);
    } else {
      final message = !borrowStatus.value ? 'Currently Borrowing' : 'Component returned';
      _showQrDialog(context, name, studentId, null, message);
    }
  }

  void _showQrDialog(
      BuildContext context,
      String name,
      String studentId,
      String? remainingBooklets,
      String titleString) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          return true;
        },
        child: AlertDialog(
          backgroundColor: AppColors.BGCOLOR,
          title: Text(titleString, style: AppTextStyles.qrDetectedDialog),
          content: Text('Name: $name \nID Number: $studentId', style: AppTextStyles.qrDetectedDialog),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 500));
                startScanning();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    ).then((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      startScanning();
    });
  }

  Future<String> _fetchClaimableBooklets(String studentId) async {
    try {
      final studentData = await _service.getStudentById(studentId);
      return studentData?[AppStrings.CLAIMABLEBOOKLET]?.toString() ?? '0';
    } catch (e) {
      debugPrint('Error fetching remaining booklets: $e');
      return '';
    }
  }

  Future<void> onQrDetect(BuildContext context, BarcodeCapture capture) async {
    if (isScanning.value) {
      stopScanning();
      final code = capture.barcodes.first.rawValue;
      if (code != null) {
        debugPrint('code: $code');
        handleQrCode(context, code);
      }
    }
  }

  Future<void> _editStudent(String name, String idNumber, bool isBorrowing) async {
    final now = DateTime.now();
    final studentData = {
      AppStrings.STUDENT_NAME: name,
      AppStrings.STUDENT_ID: idNumber,
      AppStrings.BORROWSTATUS: isBorrowing,
    };

    final attendanceData = {
      AppStrings.DATE: _formatDate(now),
      AppStrings.TIME: _formatTime(now),
      AppStrings.EVENTID: BaseController.selectedEvent.value.id,
    };

    final updateData = {
      AppStrings.BORROWSTATUS: borrowStatus.value,
    };

    final updateDataDetails = {
      AppStrings.DATE: _formatDate(now),
      AppStrings.TIME: _formatTime(now),
      AppStrings.DATERETURNED: '',
      AppStrings.TIMERETURNED: '',
    };

    if (isBorrowing) {
      borrowStatus.value = !borrowStatus.value;
      if (borrowStatus.value) {
        updateDataDetails[AppStrings.DATERETURNED] = _formatDate(now);
        updateDataDetails[AppStrings.TIMERETURNED] = _formatTime(now);
      }
    }

    try {
      await _service.createStudent(
        studentData,
        attendanceData,
        updateData,
        updateDataDetails,
      );
      debugPrint('Attendance recorded');
    } catch (e) {
      debugPrint('Error adding attendance record: $e');
      showSnackBar('Error', 'Failed to add attendance record', Colors.red);
    }
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String _formatTime(DateTime time) => DateFormat('HH:mm:ss').format(time);

  @override
  void onClose() {
    isTorchEnabled.value = false;
    super.onClose();
  }
}
