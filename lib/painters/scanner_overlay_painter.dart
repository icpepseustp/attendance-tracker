import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double overlaySize;

  const ScannerOverlayPainter({
    required this.overlaySize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.UNDERLINECOLOR
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Define the size and position of the scanner overlay
    final double overlayWidth = size.width * overlaySize;
    final double overlayHeight = size.height * (overlaySize * 0.6);
    final double offsetX = (size.width - overlayWidth) / 2;
    final double offsetY = (size.height - overlayHeight) / 2;

    final overlayRect = Rect.fromLTWH(
      offsetX,
      offsetY,
      overlayWidth,
      overlayHeight,
    );

    // Define the lengths for the edges
    final double edgeLength = 50.0; // Adjust as needed

    // Draw the overlay edges
    canvas.drawLine(
      overlayRect.topLeft,
      overlayRect.topLeft.translate(edgeLength, 0),
      paint,
    );
    canvas.drawLine(
      overlayRect.topLeft,
      overlayRect.topLeft.translate(0, edgeLength),
      paint,
    );

    canvas.drawLine(
      overlayRect.topRight,
      overlayRect.topRight.translate(-edgeLength, 0),
      paint,
    );
    canvas.drawLine(
      overlayRect.topRight,
      overlayRect.topRight.translate(0, edgeLength),
      paint,
    );

    canvas.drawLine(
      overlayRect.bottomLeft,
      overlayRect.bottomLeft.translate(edgeLength, 0),
      paint,
    );
    canvas.drawLine(
      overlayRect.bottomLeft,
      overlayRect.bottomLeft.translate(0, -edgeLength),
      paint,
    );

    canvas.drawLine(
      overlayRect.bottomRight,
      overlayRect.bottomRight.translate(-edgeLength, 0),
      paint,
    );
    canvas.drawLine(
      overlayRect.bottomRight,
      overlayRect.bottomRight.translate(0, -edgeLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // Return true if the painting needs to be updated
  }
}
