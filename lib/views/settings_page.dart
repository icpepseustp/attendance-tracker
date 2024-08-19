import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends BaseView {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: NavbarWidget(currentPage: Routes.SETTINGS),
    );
  }
}