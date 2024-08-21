import 'package:attendance_tracker/controllers/history_controller.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/utils/constants/icons.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:attendance_tracker/widgets/student_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppIcons.DELETEICON,
                  color: AppColors.HISTORYICONCOLOR,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(width: 20),
                SvgPicture.asset(
                  AppIcons.SEARCHICON,
                  color: AppColors.HISTORYICONCOLOR,
                  width: 35,
                  height: 35,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StudentDetailsWidget(
                    studentDetails: controller.studentDetails,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
