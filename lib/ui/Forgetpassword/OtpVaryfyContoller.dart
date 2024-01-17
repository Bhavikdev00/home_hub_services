import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

class OtpVaryContoller extends GetxController{
  RxBool checkFirebaseOtp = false.obs;

  RxBool isLoading = false.obs;
  RxBool CreateAotpWigits = true.obs;
  CollectionReference otpService = FirebaseFirestore.instance.collection('otp');
  late final List<TextEditingController> controllers;
  late final List<RxString> otpValues;
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool error = false.obs;

  void onInit() {
    super.onInit();
    controllers = List.generate(6, (_) => TextEditingController());
    otpValues = List.generate(6, (_) => RxString(''));
    user.bindStream(_auth.authStateChanges());
    _bindControllers();
  }


  void check(bool error1){
    error.value = error1;
    print(error.value);
  }
  void _bindControllers() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        otpValues[i].value = controllers[i].text;
      });
    }
  }

  RxBool canResend = true.obs;
  RxInt resendTimeout = 30.obs;
  late Rx<Timer?> _timer = Rx<Timer?>(null);
  Future<void> Otpsend(String email) async {
    isLoading(true);
    canResend.value = false;
    resendTimeout.value = 30;
    await resendOtp(email);
    _timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimeout.value > 0) {
        resendTimeout.value--;
      } else {
        canResend.value = true;
        _timer.value?.cancel();
      }
    });

  }

  resendOtp(String email) async {
    String secret = 'asdnasjdnasjdnasjdasdnasjdnajsdndnasdjnasd';
    String otp = OTP.generateTOTPCode(secret, DateTime.now().millisecondsSinceEpoch).toString();
    final smtpServer = gmail('zsp.bhavik@gmail.com', 'iwvu vtof svpj ubfc');
    // Create the email message
    final message = Message()
      ..from = Address('vyasparth451@gmail.com', 'Help Harbor')
      ..recipients.add(email)
      ..subject = 'Email Verification OTP'
      ..html = '''
     <!DOCTYPE html>
<html>

<head>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      color: #333;
      margin: 0;
      padding: 0;
      text-align: center;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
      color: #007bff;
    }

    .verification-code {
      color: #007bff;
      font-size: 36px;
      margin: 20px 0;
    }

    .expire-message {
      color: #dc3545;
      margin-top: 10px;
    }

    .notice {
      color: #28a745;
      margin-top: 10px;
    }

    .support-info {
      margin-top: 20px;
    }

    .contact-link {
      color: #007bff;
      text-decoration: none;
      font-weight: bold;
    }
  </style>
</head>

<body>
  <div class="container">
    <h2>Home Hub Email Verification</h2>
    <p>Dear User,</p>
    <p>Your verification code for Home Hub is:</p>
    <h1 class="verification-code">$otp</h1>
    <p class="expire-message">This code will expire in 5 minutes.</p>
    <p class="notice">Please do not share this code with anyone for security reasons.</p>
    <p>If you have any questions or need assistance, feel free to reach out to our support team.</p>
    <div class="support-info">
      <p>Contact us at: <a class="contact-link" href="mailto:support@homehub.com">support@homehub.com</a></p>
    </div>
    <p>Thank you for choosing Home Hub!</p>
  </div>
</body>

</html>

    ''';

    try {
      final sendReport = await send(message, smtpServer);

      print('Message sent: ${sendReport.toString()}');

      await sendOTPTOFirebase(email,otp);
      CreateAotpWigits(false);
      print(CreateAotpWigits);
      isLoading(false);
    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }

  }

  Future<void> sendOTPTOFirebase(String email, String otp) async {
    try{
      await otpService.doc(email).set({
        'email' : email,
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(), // Store server timestamp
      });
    }catch(e){
      print('Error sending OTP data: $e');
    }
  }

  // Get.offNamed(Routes.otpCheck);
  Future<bool> checkOTPFromFirestore(String email) async {
    try{
      checkFirebaseOtp(true);
      DocumentSnapshot snapshot = await otpService.doc(email).get();
      if(snapshot.exists){
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String storedOTP = data['otp'];
        Timestamp timestamp = data['timestamp'];
        int currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        int storedTimeInSeconds = timestamp.seconds;
        int timeDifference = currentTimeInSeconds - storedTimeInSeconds;
        String otp =  otpValues.map((otpValue) => otpValue.value).join();
        if (otp == storedOTP && timeDifference <= 110) {
          checkFirebaseOtp(false);
          print("Succeed");
          return true; // OTP matches and within the time limit
        }
        else{
          clearAllFields();
          Get.snackbar(
            "Email is Not Varify",
            "Try Again",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.notification_add),
          );
          checkFirebaseOtp(false);
        }
      }
    }catch (e) {
      print('Error checking OTP: $e');
    }
    return false;
  }

  void clearAllFields() {
    for (final controller in controllers) {
      controller.clear();
    }
    for (final value in otpValues) {
      value.value = '';
    }
  }
}