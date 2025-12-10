import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/main_dashboard_screen.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(
        _auth.userChanges()); // ALWAYS LISTEN TO THE USER STATE
    ever(firebaseUser,
        _setInitialScreen); //ALWAYS READY TO LISTEN TO THE USER STATE CHANGES
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get
        .offAll(() => const UserDashboard());
  }

  Future<void> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white
      );
    }
    Future<void> loginWithEmailAndPassword(String email,
        String password) async {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
      } catch (e) {
        Get.snackbar("Error Creating Account", e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white
        );
      }


      Future<void> logout() async {
        await _auth.signOut();
      }
    }
  }
}
