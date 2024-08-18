import 'package:attendance_tracker/views/base_view.dart';
import 'package:attendance_tracker/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class ScanPage extends BaseView {
  const ScanPage({Key? key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: NavbarWidget(),
    );
  }
}