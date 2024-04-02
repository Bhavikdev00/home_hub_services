import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../getstorage/StorageClass.dart';

class ResetPasswordController extends GetxController {
  var isPasswordVisible = true.obs;
  var cisPasswordVisible = true.obs;
  StorageService storageService = StorageService();
  var isLoading = false.obs;
  var userEmail = "".obs;
  var userPassword = "".obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController CpasswordController = TextEditingController();
  CollectionReference updatePassword = FirebaseFirestore.instance.collection('service_providers');
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleCpasswordVisiblity() {
    cisPasswordVisible.value = !cisPasswordVisible.value;
  }
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CpasswordController.dispose();
    passwordController.dispose();
  }
  @override
  Future<void> onInit() async {
    super.onInit();
    final Map<String, dynamic>? arguments =
        Get.arguments as Map<String, dynamic>?;
    final String email = arguments?['email'] ?? '';
    loadDataInFirebase(email);
  }

  Future<void> loadDataInFirebase(String email) async {
    try {
      print(email);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('service_providers')
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String useremails = querySnapshot.docs[0].get('email') as String;
        String password = querySnapshot.docs[0].get('password') as String;
        userEmail.value = useremails;
        userPassword.value = password;
        print(userPassword.value);
      } else {
        print("Nothing");
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<bool> changePassword() async {
    try {
      isLoading(true);

      // Printing out the user's email and password for debugging purposes
      print("Email is ${userEmail.value}");
      print("Password is ${userPassword.value}");

      // Attempting to sign in with the provided email and password using FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail.value,
        password: userPassword.value,
      );

      // If the sign-in is successful, print out the UID of the user
      User? user = userCredential.user;
      if(user != null){
        await user.updatePassword(CpasswordController.text.toString());
        await updatePasswordinFirebase(CpasswordController.text.toString());
        isLoading(false);
        return true;
      }else{
        isLoading(false);
        print("No user is currently signed in.");
        return false;

      }
      // Return true to indicate that the password change was successful
      return true;
    } catch (e) {
      // If any error occurs during the sign-in process, catch it and print the error message
      print("${e.toString()}");

      // Return false to indicate that the password change was unsuccessful
      return false;
    }
  }


  Future<void> updatePasswordinFirebase(String passwords) async {
    try{
      String uid = storageService.getUserid();
      print( "User id is $uid");
      final DocumentReference documentReference = FirebaseFirestore.instance.collection('service_providers').doc(uid);
      await documentReference.update({
        "password" : passwords
      });
    }catch(e){
      print('Error sending OTP data: $e');
    }
  }
}
