import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

import '../../../ModelClasses/OrderResModel.dart';
import '../../../ModelClasses/user.dart';
import '../../../getstorage/StorageClass.dart';
import '../../notification_services/notification_service.dart';

class OtpVarificationConntroller extends GetxController{
  final StorageService _storageService = StorageService();
  List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  bool otpfilled = false;
  int start = 30; // Observable for countdown timer
  Timer? _timer;
  bool enableResend = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startTimer();
  }

  void startTimer() {
    start = 30;
    update();
    const oneSec = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          timer.cancel();
          enableResend = true;
          update();
        } else {
          start--;
          update();
        }
      },
    );
  }


  String getOtpFromScreen() {
    String otp = "";
    otpControllers.forEach((element) {
      otp += element.text;
    });
    return otp;
  }

  isOtpFielled() {
    otpfilled = false;
    update();
    if (otpControllers[0].text.isNotEmpty &&
        otpControllers[1].text.isNotEmpty &&
        otpControllers[2].text.isNotEmpty &&
        otpControllers[3].text.isNotEmpty &&
        otpControllers[4].text.isNotEmpty &&
        otpControllers[5].text.isNotEmpty) {
      otpfilled = true;
    }
    update();
  }

  Future<void> resendOtp({required String email}) async {
    String secret = 'asdnasjdnasjdnasjdasdnasjdnajsdndnasdjnasd';
    String otp = OTP
        .generateTOTPCode(secret, DateTime.now().millisecondsSinceEpoch,
        length: 6)
        .toString();
    final smtpServer = gmail('zsp.bhavik@gmail.com', 'iwvu vtof svpj ubfc');
    // Create the email message
    final message = Message()
      ..from = const Address('vyasparth451@gmail.com', 'Home Hub')
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
    <h2>Home Hub Services Email Verification</h2>
    <p>Dear User,</p>
    <p>Your verification code for Home Hub Services is:</p>
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
      await _storageService.updateOtp(otp);

      // await sendOTPTOFirebase(email, otp);
    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }
  }


  Future<bool> varifyOtp(String otp) async {
    enableResend = false;
    update();
    startTimer();
    String correctOtp = await _storageService.getOtp();
    if (otp == correctOtp) {
      return true;
    } else {
      Get.snackbar("Wrong otp", "Please Enter valid otp");
      return false;
    }
  }



  Future<void> comp(OrderResModel order, UserData userdata) async {
    String name = _storageService.getName();

    order.status = "Completed";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
    NotificationService.sendMessage(
      msg: "Services Completed",
      title: "$name",
      receiverFcmToken: userdata.fcmToken,
      Data: {
        "ServiceId" : order.serviceProviderId,
        "ServiceName" : order.servicesName,
        "click_action" : "ratting",
        "subServiceId" :order.subServiceId,
      },
    );
  }



}