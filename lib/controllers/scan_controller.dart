import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/controllers/booklet_controller.dart';
import 'package:attendance_tracker/controllers/borrow_controller.dart';
import 'package:attendance_tracker/controllers/event_controller.dart';
import 'package:attendance_tracker/controllers/events_selection_controller.dart';
import 'package:attendance_tracker/controllers/usage_selection_controller.dart';
import 'package:attendance_tracker/firebase/firestore_service.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/strings.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanController extends BaseController {
  ScanController(this._service, this.usageSelectionController)
      : _eventController = EventController(_service),
        _bookletController = BookletController(_service, usageSelectionController),
        _borrowController = BorrowController(_service, usageSelectionController),
        eventsSelectionController = EventsSelectionController(_service){
        // Conditionally initialize EventsSelectionController
        // Check if EventsSelectionController is registered
        if (Get.isRegistered<EventsSelectionController>()) {
          // If registered, retrieve the existing instance
          eventsSelectionController = Get.find<EventsSelectionController>();
        }
      }

  // get the firestore service
  final FirestoreService _service;

  // initialize the controller for each usage
  final EventController _eventController;
  final BookletController _bookletController;
  final BorrowController _borrowController;
  final UsageSelectionController usageSelectionController;
  late EventsSelectionController eventsSelectionController;

  late bool isEventAttendance;
  late bool isBooklet;
  late bool isBorrowing;

  @override
  void onInit() {
    super.onInit();
    isEventAttendance = usageSelectionController.selectedUsage.value.description == AppStrings.EVENTATTENDANCE;
    isBooklet = usageSelectionController.selectedUsage.value.description == AppStrings.BOOKLET;
    isBorrowing = usageSelectionController.selectedUsage.value.description == AppStrings.BORROWCOMPONENTS;
  }

  // initialize the scanning status of the scanner
  var isScanning = true.obs;

  // set the overlaysize of the scanner painter overlay
  var overlaySize = 0.7.obs;

  // initialize the flash status of the camera
  var isTorchEnabled = false.obs;

  // get the controller for the mobile scanner
  final MobileScannerController mobileScannerController = MobileScannerController();

  // get the torch icon when it is enabled or disabled
  String getTorchIcon() =>isTorchEnabled.value ? AppIcons.TORCHONICON : AppIcons.TORCHOFFICON;

  void toggleTorch() {
    debugPrint('Torch clicked');
    mobileScannerController.toggleTorch();
    isTorchEnabled.value = !isTorchEnabled.value;
  }

  void _stopScanning() => isScanning.value = false;

  void _startScanning() => isScanning.value = true;

  // function for handling the painter size when the user wants to adjust it
  void handleDisplaySizeChange(double value) => overlaySize.value = value;

  // handling qr code 
  void _handleQrCode(BuildContext context, String code) async {
   debugPrint('the code for the scanned QR code is: $code');

    // Use a regular expression to match name and ID number.
    final RegExp namePattern = RegExp(r'Name:\s*([\w\s.]+)(?=\s+ID Number)');
    final RegExp idPattern = RegExp(r'ID Number:\s*(\d+)');

    // Try matching using both patterns.
    final nameMatch = namePattern.firstMatch(code);
    final idMatch = idPattern.firstMatch(code);

    String name = '';
    String studentId = '';

    // If it matches the first format (with "Name:" and "ID Number:")
    if (nameMatch != null && idMatch != null) {
      name = nameMatch.group(1)!.trim();  // Extract the name.
      studentId = idMatch.group(1)!.trim(); // Extract the ID.
    } 
    // If it matches the second format (just name and ID without labels)
    else {
      final stringParts = code.split(RegExp(r'\s+'));
      if (stringParts.length >= 2) {
        name = stringParts.sublist(0, stringParts.length - 1).join(' ').trim(); // Extract the name.
        studentId = stringParts.last.trim();
      }
    }


    // Determine the message and remaining booklets based on usage type
    String? remainingBooklets;
    String message;
    

    if (isEventAttendance) {
      message = eventsSelectionController.selectedEvent.value.description;
      await _eventController.recordEventAttendance(name, studentId, eventsSelectionController.selectedEvent.value.id);
    } else if (isBooklet) {
      remainingBooklets = await _bookletController.fetchClaimableBooklets(studentId);
      message = remainingBooklets == '0'
          ? 'No more booklets left'
          : 'Claimable Booklets: $remainingBooklets';
    } else {
      _borrowController.borrowStatus.value = await _borrowController.getCurrentBorrowStatus(studentId);
      message = !_borrowController.borrowStatus.value
          ? 'Currently Borrowing'
          : 'Component returned';
    }

    // Show the QR dialog with the appropriate details
    _showQrDialog(context, name, studentId, remainingBooklets, message);
  }



  void _showQrDialog(BuildContext context, String name, String studentId,
      String? remainingBooklets, String titleString) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          return true;
        },
        child: AlertDialog(
          backgroundColor: AppColors.BGCOLOR,
          title: Text(titleString, style: AppTextStyles.QRDETECTEDDIALOG),
          content: handleQrDialogContent(name, studentId),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await handleRecordData(name, studentId);
                await Future.delayed(const Duration(milliseconds: 1000));
                _startScanning();
              },
              child: Text('DONE',
                  style: AppTextStyles.QRDETECTEDDIALOG
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onQrDetect(BuildContext context, BarcodeCapture capture) async {
    if (isScanning.value) {
      _stopScanning();
      final code = capture.barcodes.first.rawValue;
      if (code != null) {
        debugPrint('code: $code');
        _handleQrCode(context, code);
      }
    }
  }


  // handle which dialog to display
  dynamic handleQrDialogContent(String name, String studentId) {
    if (isEventAttendance) {
      return _eventController.eventAlertDialog(name, studentId);
    } else if (isBooklet) {
      return _bookletController.bookletAlertDialog(name, studentId);
    } else {
      return _borrowController.borrowAlertDialog(name, studentId);
    }
  }

  // handle when the user clicks 'DONE' on the dialog
  // this does not include event attendance because it will automatically record a data for event attendance when isEventAttendance is true
  // this is to ensure a fast attendance tracking
  Future<void> handleRecordData(String name, String studentId) async {
    try {
      if (isBooklet) {
        await _bookletController.recordClaimableBooklets(studentId, name);
      } else if(isBorrowing) {
        await _borrowController.recordBorrowComponent(name, studentId);
      }
    } catch (e) {
      debugPrint('Error handling record data: $e');
    }
  }

  @override
  void onClose() {
    isTorchEnabled.value = false;
    super.onClose();
  }
}
