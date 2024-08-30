import 'package:attendance_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles{
  
  static final TextStyle NAVICONLABELPOPPINS = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 16,
      color: AppColors.ICONCOLOR
    )
  );

  static final TextStyle STUDENTDETAILS = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 17,
      color: AppColors.HISTORYICONCOLOR
    )
  );

  static final TextStyle STUDENTDETAILSSUBTEXT = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppColors.HISTORYICONCOLOR,
      fontSize: 15,
    )
  );

  static final TextStyle SELECTEVENTLABEL = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppColors.NAVBARCOLOR,
      fontSize: 20,
      fontWeight: FontWeight.bold
    )
  );

  static final TextStyle BUTTONTEXT = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    )
  );

  static final TextStyle QRDETECTEDDIALOG= GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppColors.NAVBARCOLOR,
      fontSize: 16
    )
  );

  static final TextStyle SETTINGSTEXTSTYLE = GoogleFonts.poppins(
    textStyle: const TextStyle(
      color: AppColors.NAVBARCOLOR,
      fontSize: 19
    )
  );
}