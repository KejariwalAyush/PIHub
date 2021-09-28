import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/config/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  @override
  Widget build(BuildContext context) {
    Get.put(() => SigninController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: kcWhite),
                height: 100,
                width: 100,
                child: Image.asset('assets/icon.png')),
            [
              'PIHub'.text.xl4.make(),
              'Find Projects & ideas in single place'.text.sm.make(),
            ].column(),
            Container(
                width: context.width * 0.8,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: kcMain,
                  ),
                  onPressed: controller.sigin,
                  child: Center(
                      child: Text(
                    "Login with google",
                    style: TextStyle(color: Colors.white),
                  )),
                )),
          ],
        ),
      ),
    );
  }
}
