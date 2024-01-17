import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/constraint/app_assets.dart';
import 'package:home_hub_services/ui/Forgetpassword/OtpVaryfyContoller.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final _emails = TextEditingController();
  final _globelKey = GlobalKey<FormState>();
  OtpVaryContoller _otpVaryContoller = Get.put(OtpVaryContoller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:  Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Home Hub Services",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _globelKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "OTP Verification",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  7.h.addHSpace(),
                  Row(
                    children: [
                      Text(
                        "Don't worry",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    "We are here to help you to recover your password Enter the email address you used when you joined and we'll send you the link to reset your Password ",
                    style: TextStyle(fontSize: 16),
                  ),
                  2.h.addHSpace(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email"),
                          2.h.addHSpace(),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  !AppAssets.isvalidemail(value)) {
                                return "Enter the Validate Email";
                              } else {
                                return null;
                              }
                            },
                            controller: _emails,
                            decoration: InputDecoration(
                                hintText: "example@example.com",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                          4.h.addHSpace(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios_new),
                                    Text("Back")
                                  ],
                                ),
                              ),
                              Obx(
                                () => _otpVaryContoller.isLoading.value ? LoadingAnimationWidget.hexagonDots(
                                    color: appColor, size: 5.h): ElevatedButton(
                                    onPressed: () async {
                                      // var emails = _emails.text.toString();
                                      // Get.toNamed(Routes.otpInForgetPassword,arguments: {
                                      //   "email" : emails
                                      // });
                                      if (_globelKey.currentState!.validate()) {
                                         var emails = _emails.text.toString();
                                         await _otpVaryContoller.Otpsend(emails);
                                         Get.toNamed(Routes.otpInForgetPassword,arguments: {
                                          "email" : emails
                                         });
                                      } else {
                                        print("Invalid Emails");
                                      }
                                    },
                                    child: Text("Send")),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
