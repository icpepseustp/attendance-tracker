import 'package:attendance_tracker/controllers/history_controller.dart';
import 'package:attendance_tracker/models/student_details_model.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:attendance_tracker/widgets/qr_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailsWidget extends BaseWidget {
  final List<StudentDetailsModel> studentDetails;
  final HistoryController controller;

  const StudentDetailsWidget({
    Key? key,
    required this.studentDetails,
    required this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.handleHistoryDisplay());
  }
}
