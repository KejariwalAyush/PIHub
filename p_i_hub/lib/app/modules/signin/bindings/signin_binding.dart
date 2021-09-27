import 'package:get/get.dart';
import 'package:p_i_hub/app/modules/signin/controllers/splash_controller.dart';

import '../controllers/signin_controller.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
    Get.lazyPut<SigninController>(
      () => SigninController(),
    );
  }
}
