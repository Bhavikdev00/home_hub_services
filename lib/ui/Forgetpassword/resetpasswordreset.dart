import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ResetPasswordController extends GetxController {
  var isPasswordVisible = true.obs;
  var cisPasswordVisible = true.obs;
  var isLoading = false.obs;
  var userEmail = "".obs;
  var userPassword = "".obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController CpasswordController = TextEditingController();
  CollectionReference updatePassword = FirebaseFirestore.instance.collection('ServiceProviderProfileInfo');
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
    await loadDataInFirebase(email);
  }

  Future<void> loadDataInFirebase(String email) async {
    try {
      print(email);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ServiceProviderProfileInfo')
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail.value,
        password: userPassword.value,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updatePassword(CpasswordController.text.toString());
        print("Password updated successfully!");
        await UpdatePassword(CpasswordController.text.toString());
        isLoading(false);
        return true;
      } else {

        isLoading(false);
        print("No user is currently signed in.");
        return false;
      }
    } catch (e) {
      // Handle error
      isLoading(false);
      return false;
    }
  }

  Future<void> UpdatePassword(String passwords) async {
    try{
      QuerySnapshot querySnapshot = await updatePassword.where('email', isEqualTo: userEmail.value).get();

      // await updatePassword.where("email",isEqualTo: userEmail.value).set({
      //   'email' : email,
      //   'otp': otp,
      //   'timestamp': FieldValue.serverTimestamp(), // Store server timestamp
      // });
      String ids = querySnapshot.docs[0].id;
     await  updatePassword.doc(ids).update({
        'password': passwords,
        // add more fields to update if needed
      });
    }catch(e){
      print('Error sending OTP data: $e');
    }
  }
}
