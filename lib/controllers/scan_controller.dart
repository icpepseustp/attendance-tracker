import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanController extends BaseController {
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
  

  Future<void> onQrDetect(BuildContext context, BarcodeCapture capture) async {
    if (isScanning.value) {
      // Pause scanning
      stopScanning();

      final List<Barcode> barcodes = capture.barcodes;
      final Barcode firstBarcode = barcodes.first;
      if (firstBarcode.rawValue != null) {
        final String code = firstBarcode.rawValue!;
        handleQrCode(context, code);
      }
    }
  }

  void handleQrCode(BuildContext context, String code) {
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
          title: const Text('QR Code Found'),
          content: Text('Data: $code'),
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



}