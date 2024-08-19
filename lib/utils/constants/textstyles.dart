import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles{
  
  static final TextStyle navIconLabelPoppins = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 16,
      color: AppColors.ICONCOLOR
    )
  );

  static final TextStyle studentDetails = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 20,
      color: AppColors.HISTORYICONCOLOR
    )
  );

  static final TextStyle DateAndTime = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppColors.HISTORYICONCOLOR,
      fontSize: 18
    )
  );

}