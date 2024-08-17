import 'package:app/bindings/base_binding.dart';
import 'package:app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends BaseBinding {

  @override
  void dependencies() {
    Get.lazyPut<SplashController> ( 
      () => SplashController()
    );
  }
}