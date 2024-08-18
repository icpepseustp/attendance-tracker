// app_pages.dart
import 'package:get/get.dart';
import 'package:attendance_tracker/views/scan_page.dart';
import 'package:attendance_tracker/views/splash_page.dart';
import 'package:attendance_tracker/bindings/scan_binding.dart';
import 'package:attendance_tracker/bindings/splash_binding.dart';

part 'routes.dart'; // Ensure this matches the part file's part of directive

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH, // Use Routes.SPLASH here
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 3000),
    ),
    GetPage(
      name: Routes.SCAN, // Use Routes.SCAN here
      page: () => const ScanPage(),
      binding: ScanBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
