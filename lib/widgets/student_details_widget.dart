import 'package:attendance_tracker/controllers/history_controller.dart';
import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:flutter/material.dart';

class StudentDetailsWidget extends BaseWidget {
  final List<StudentDetailsModel> studentDetails;

  const StudentDetailsWidget({
    Key? key,
    required this.studentDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: studentDetails.map((student) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: 10.0), // Add bottom padding for spacing
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrWidget(), // Add a QR code widget for each student
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.studentName} - ${student.studentId}',
                      style: AppTextStyles.studentDetails,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${student.date} \t ${student.time}', // Replace with actual date and time fields if available
                      style: AppTextStyles.DateAndTime,
                    ),
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
