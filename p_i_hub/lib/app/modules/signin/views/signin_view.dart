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
            'PIHub'.text.xl4.make(),
            // 30.squareBox,
            'Find Projects & ideas in single place'.text.sm.make(),
            // 30.squareBox,
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
