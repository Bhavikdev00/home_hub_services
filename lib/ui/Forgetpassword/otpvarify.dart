import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/constraint/app_string.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';
import 'OtpVaryfyContoller.dart';

class OtpVarify extends StatelessWidget {
  OtpVarify({super.key});

  OtpVaryContoller _otpVaryContoller = Get.put(OtpVaryContoller());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        Get.arguments as Map<String, dynamic>?;
    final String email = arguments?['email'] ?? '';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.h.addHSpace(),
            AppString.forgetPasswordOtp
                .boldRoboto(fontColor: Colors.black, fontSize: 30),
            1.h.addHSpace(),
            AppString.forgetPasswordTital.boldRoboto(fontSize: 15),
            email.mediumRoboto(
                fontSize: 15,
                fontColor: Colors.black,
                textOverflow: TextOverflow.ellipsis),
            3.h.addHSpace(),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 50,
                    height: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _otpVaryContoller.controllers[index],
                      textAlign: TextAlign.center,

                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "0",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            ),

            2.h.addHSpace(),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Obx(
                    () => _otpVaryContoller.checkFirebaseOtp.value ?
                LoadingAnimationWidget.hexagonDots(
                    color: appColor, size: 5.h): appButton(onTap: () async {
                  var checkOtpStatus =await  _otpVaryContoller.checkOTPFromFirestore(email);
                  if(checkOtpStatus){
                    Get.toNamed(Routes.password,arguments: {
                      "email" : email,
                    });
                  }else{

                  }
                },
                    text: "Verify"),
              ),
            ),
            2.h.addHSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    if (!_otpVaryContoller.canResend.value) {
                      return 'Time Remaining:${_otpVaryContoller.resendTimeout.value} seconds'.mediumReadex(fontSize: 15,fontColor: Colors.black);
                    } else {
                      return ElevatedButton(
                        onPressed: _otpVaryContoller.canResend.value
                            ? () {
                          _otpVaryContoller.Otpsend(email);
                        }
                            : null,
                        child: Text('Resend OTP'),
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
