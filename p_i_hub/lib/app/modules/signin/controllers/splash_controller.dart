import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final _auth = Get.find<AuthService>();
  @override
  Future<void> onInit() async {
    super.onInit();
    print(_auth.isSignedIn());
    if (_auth.isSignedIn()) {
      QuerySnapshot<Object?> res = await getUser(_auth.getCurrentUser()!.uid);
      if (res.docs.length < 1 || res.docs.first.data() == null)
        Get.offAllNamed(Routes.SIGNUP);
      else {
        final data = jsonEncode(res.docs.first.data());
        if (data == '')
          Get.offAllNamed(Routes.SIGNUP);
        else {
          PIHub.currentProfile = Profile.fromJson(data);
          Get.offAllNamed(Routes.HOME);
        }
      }
    } else {
      await Future.delayed(2.seconds);
      Get.offAllNamed(Routes.SIGNIN);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<QuerySnapshot<Object?>> getUser(String uid) async {
    final collection = FirebaseFirestore.instance.collection('users');
    final Query query = collection.where('id', isEqualTo: uid);
    var res = await query.get();
    return res;
  }
}
