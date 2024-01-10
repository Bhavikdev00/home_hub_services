import 'dart:async';

import 'package:get/get.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

class OtpVaryContoller extends GetxController{
  RxBool canResend = true.obs;
  RxInt resendTimeout = 30.obs;
  late Rx<Timer?> _timer;
  void startResendTimer() {
    canResend.value = false;
    resendTimeout.value = 30;

    _timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimeout.value > 0) {
        resendTimeout.value--;
      } else {
        canResend.value = true;
        _timer.value?.cancel();
      }
    });
  }

  // Get.offNamed(Routes.otpCheck);

}