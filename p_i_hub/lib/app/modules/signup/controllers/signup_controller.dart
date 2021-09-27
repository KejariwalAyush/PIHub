import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  final _auth = Get.find<AuthService>();
  final collection = FirebaseFirestore.instance.collection('users');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<bool> isValidUsername(val) async {
    final query = collection.where('username', isEqualTo: val);
    var res = await query.get();
    return !(res.docs.length > 0);
  }

  Future<void> signUpUser() async {
    final user = _auth.getCurrentUser()!;
    Profile userProfile = new Profile(
        id: user.uid,
        name: user.displayName ?? '',
        username: formKey.currentState!.value['username'],
        imgUrl: user.photoURL ??
            "https://www.pctonics.com/blog/Content/Blog/images/Dummy-Profile.png",
        email: user.email ?? '',
        hashtags: formKey.currentState!.value['hashtags'],
        links: [
          if (formKey.currentState!.value['link1'] != null)
            formKey.currentState!.value['link1'],
          if (formKey.currentState!.value['link2'] != null)
            formKey.currentState!.value['link2'],
          if (formKey.currentState!.value['link3'] != null)
            formKey.currentState!.value['link3'],
        ],
        followers: [],
        following: [],
        languages: formKey.currentState!.value['languages'],
        saved: PICombo.empty(),
        liked: PICombo.empty(),
        projects: [],
        ideas: []);
    await collection
        .doc(userProfile.username)
        .set(userProfile.toMap())
        .then((value) {
      print('Data Uploaded');
      Get.offAllNamed(Routes.HOME);
    });
  }
}
