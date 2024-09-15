import 'package:attendance_tracker/models/history_model.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:flutter/material.dart';

class StudentDetailsWidget extends BaseWidget {
  final List<HistoryModel> studentDetails;
  final Widget Function(HistoryModel) buildSubText;

  const StudentDetailsWidget({
    Key? key,
    required this.studentDetails,
    required this.buildSubText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: studentDetails.map((student) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding for spacing
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70, // Ensure consistent width
                    height: 70, // Ensure consistent height
                    child: QrWidget(data: '${student.studentName} - ${student.studentId}'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student.studentName} - ${student.studentId}',
                          style: AppTextStyles.STUDENTDETAILS,
                        ),
                        const SizedBox(height: 5),
                        buildSubText(student)
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
  }
}
