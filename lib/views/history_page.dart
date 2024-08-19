import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:attendance_tracker/utils/constants/colors.dart';

class HistoryPage extends BaseView{
  const HistoryPage({Key ? key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: NavbarWidget(currentPage: Routes.HISTORY),
      backgroundColor: AppColors.BGCOLOR,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.BGCOLORDARK
            ),
          )
        ]
      )
    );
  }
}