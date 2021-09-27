import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_i_hub/app/data/config/colors.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:velocity_x/velocity_x.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());

  Vx.setPathUrlStrategy();
  runApp(
    GetMaterialApp(
      title: "PIHub",
      initialRoute: AppPages.INITIAL,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: kcMain,
        textTheme: GoogleFonts.exo2TextTheme()
            .apply(bodyColor: kcWhite, displayColor: kcWhite),
      ),
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    ),
  );
}
