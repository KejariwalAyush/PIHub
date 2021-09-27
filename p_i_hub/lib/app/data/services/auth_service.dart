import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:p_i_hub/app/data/config/index.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthService {
  Future<AuthService> init() async {
    return this;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> onAuthChanged() {
    return _auth.authStateChanges();
  }

  Future<String?> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        User? user = userCredential.user;
        if (user != null) return user.uid;

        VxToast.show(Get.context!,
            msg: "Error Signing in!",
            bgColor: Colors.red,
            textColor: Colors.white);
        return null;
      } catch (e) {
        print(e);
      }
    } else {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      User? user = _auth.currentUser;
      if (user != null) return user.uid;

      VxToast.show(Get.context!,
          msg: "Error Signing in!",
          bgColor: Colors.red,
          textColor: Colors.white);
      return null;
    }
  }

  bool isSignedIn() {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  User? getCurrentUser() {
    User? user = _auth.currentUser;
    return user;
  }

  Future<String> getAccessToken() async {
    User? user = getCurrentUser();
    IdTokenResult tokenResult = await user!.getIdTokenResult();
    return tokenResult.token ?? '';
  }

  Future<String> getRefreshToken() async {
    User? user = getCurrentUser();
    IdTokenResult tokenResult = await user!.getIdTokenResult(true);
    return tokenResult.token ?? '';
  }

  Future<void> signOut() async {
    return Future.microtask(() {
      _auth.signOut();
      _googleSignIn.signOut();
      PIHub.currentProfile = null;
    });
  }

  Future<void> deleteUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      user.delete().then((_) {
        VxToast.show(Get.context!, msg: "Succesfully deleted user");
      }).catchError((error) {
        VxToast.show(Get.context!,
            msg: "user can't be delete" + error.toString(),
            bgColor: Colors.red,
            textColor: Colors.white);
      });
    } else
      VxToast.show(Get.context!,
          msg: "Error Deleting Account",
          bgColor: Colors.red,
          textColor: Colors.white);
    return null;
  }
}
