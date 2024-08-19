import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends BaseWidget {
  @override
  Widget build(BuildContext context){
    return Center(
      child: QrImageView(
        data: 'Hello world',
        version: QrVersions.auto,
        size: 70.0,
        foregroundColor: AppColors.HISTORYICONCOLOR,
      ),
    );
  }
}