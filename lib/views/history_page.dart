import 'package:attendance_tracker/controllers/history_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:attendance_tracker/widgets/student_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HistoryPage extends BaseView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(currentPage: Routes.HISTORY),
      backgroundColor: AppColors.BGCOLOR,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(color: AppColors.BGCOLORDARK),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller.dateController,
                decoration: const InputDecoration(
                  labelText: 'DATE',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                  prefixIcon: Icon(Icons.calendar_today, size: 19, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.NAVBARCOLOR),
                  ),
                ),
                
                onTap: () => controller.selectDate(context),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Obx(() => controller.handleHistoryDisplay()),
            ),
          ),
        ],
      ),
    );
  }
}
