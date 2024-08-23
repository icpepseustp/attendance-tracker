// app_pages.dart
import 'package:attendance_tracker/bindings/events_selection_binding.dart';
import 'package:attendance_tracker/bindings/history_binding.dart';
import 'package:attendance_tracker/bindings/settings_binding.dart';
import 'package:attendance_tracker/views/events_selection_page.dart';
import 'package:attendance_tracker/views/history_page.dart';
import 'package:attendance_tracker/views/settings_page.dart';
import 'package:get/get.dart';
import 'package:attendance_tracker/views/scan_page.dart';
import 'package:attendance_tracker/views/splash_page.dart';
import 'package:attendance_tracker/bindings/scan_binding.dart';
import 'package:attendance_tracker/bindings/splash_binding.dart';

part 'routes.dart'; // Ensure this matches the part file's part of directive

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH, 
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 3000),
    ),
    GetPage(
      name: Routes.EVENTS, 
      page: () => const EventsSelectionPage(),
      binding: EventsSelectionBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.SCAN, 
      page: () => const ScanPage(),
      binding: ScanBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.HISTORY, 
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.SETTINGS, 
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
