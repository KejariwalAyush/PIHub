import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/config/colors.dart';
import 'package:p_i_hub/app/modules/signin/controllers/splash_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: kcSec,
      body: Center(
        child: [
          'PIHub'.text.xl4.make(),
          30.squareBox,
          'Find Projects & ideas in single place'.text.sm.make()
        ].column(),
      ),
    );
  }
}
