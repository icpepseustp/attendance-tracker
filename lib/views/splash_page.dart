import 'package:app/controllers/splash_controller.dart';
import 'package:app/views/base_view.dart';
import 'package:flutter/material.dart';

class SplashPage extends BaseView<SplashController> {
  
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("SplashPage initialized ${controller.initialized}");
    return Scaffold (
        body : Center (
      child: Container (
          color: Colors.white,
          child: Align (
            alignment: Alignment.center,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(),
                Text (
                  "XXX", 
                  style: const TextStyle (
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.indigo
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}