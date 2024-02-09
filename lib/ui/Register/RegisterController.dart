import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/utils/app_routes.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);

  String? get userId => user.value?.uid;
  RxBool isLoading = false.obs;
  var isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {

    super.onClose();
  }
@override
  void dispose() {
  emailController.dispose();
  passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }
}
