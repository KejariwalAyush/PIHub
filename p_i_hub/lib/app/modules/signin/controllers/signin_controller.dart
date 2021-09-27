import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/routes/app_pages.dart';
import 'package:velocity_x/velocity_x.dart';

class SigninController extends GetxController {
  final _auth = Get.find<AuthService>();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> sigin() async {
    VxToast.showLoading(Get.context!);
    String? uid = await _auth.signInWithGoogle();
    if (uid == null)
      VxToast.show(Get.context!,
          msg: "Error", bgColor: Colors.red, textColor: Colors.white);
    else {
      QuerySnapshot<Object?> res = await getUser(uid);
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
    }
  }

  Future<QuerySnapshot<Object?>> getUser(String uid) async {
    final collection = FirebaseFirestore.instance.collection('users');
    final Query query = collection.where('id', isEqualTo: uid);
    var res = await query.get();
    return res;
  }
}
