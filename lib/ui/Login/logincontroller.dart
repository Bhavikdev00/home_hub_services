import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getstorage/StorageClass.dart';


class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();
  Rx<User?> user = Rx<User?>(null);
  String? get userId => user.value?.uid;
  RxBool isLoading = false.obs;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  Future<dynamic> signInWithEmailAndPassword() async {
    try {
      isLoading(true);
      print("Call");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("Call1");
      // Get.offAllNamed(Routes.homeScreen);
      _storageService.loginStatusCheck(true);
      isLoading(false);
      return userCredential;
    } on FirebaseAuthException catch (e) {

      isLoading(false);
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Login Error',
          'No user found for that email',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Login Error',
          'Wrong password provided for that user',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Login Error',
          'Invalid email address',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else {
        Get.snackbar(
          'Login Error',
          'Error: Invalid email address And Password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      }
      print('Login failed: $e');
    } catch (e) {
      // Catch other exceptions
      print('Login failed: $e');
      Get.snackbar(
        'Login Error',
        'Failed to sign in: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return e.toString();
    }
  }


}
