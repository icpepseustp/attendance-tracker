import 'package:app/bindings/splash_binding.dart';
import 'package:app/views/login_page.dart';
import 'package:app/views/splash_page.dart';
import 'package:get/get.dart';
part 'routes.dart';

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
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: null,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 3000),
    ),
  ];
}