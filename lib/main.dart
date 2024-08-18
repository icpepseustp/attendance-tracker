import 'package:attendance_tracker/bindings/splash_binding.dart';
import 'package:attendance_tracker/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Get.put(new FirebaseAuthService());
  //Get.put(new FirestoreService());
  //Get.put(new FirebaseStorageService());
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: SplashBinding(),
    initialRoute: Routes.SPLASH,
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
  ));
}