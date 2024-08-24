import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:attendance_tracker/utils/constants/textstyles.dart';
import 'package:attendance_tracker/widgets/base_widgets.dart';
import 'package:flutter/material.dart';

class SelectionOptionWidget extends BaseWidget {
  final String optionDescription;
  final String optionId;
  final Function(String, String) onPressed;


  const SelectionOptionWidget({
    Key? key, 
    required this.optionDescription, 
    required this.onPressed,
    required this.optionId
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(optionDescription, optionId),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.NAVBARCOLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      ),
      child: Text(optionDescription,
          style: AppTextStyles.BUTTONTEXT, textAlign: TextAlign.center),
    );
  }
}
