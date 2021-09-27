import 'package:get/get.dart';

import 'package:p_i_hub/app/modules/home/bindings/home_binding.dart';
import 'package:p_i_hub/app/modules/home/views/home_view.dart';
import 'package:p_i_hub/app/modules/signin/bindings/signin_binding.dart';
import 'package:p_i_hub/app/modules/signin/views/signin_view.dart';
import 'package:p_i_hub/app/modules/signin/views/splash_view.dart';
import 'package:p_i_hub/app/modules/signup/bindings/signup_binding.dart';
import 'package:p_i_hub/app/modules/signup/views/signup_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
