import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../constraint/app_color.dart';
import 'RegisterDetailsController.dart';

class OtpCheck extends StatelessWidget {
  OtpCheck({super.key});
  RegisterDetailsController _registerContoller = Get.put(RegisterDetailsController());
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String email = arguments?['email'] ?? '';
    final String password = arguments?['password'] ?? '';
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => _registerContoller.loadAddData.value ? LoadingAnimationWidget.hexagonDots(
                    color: appColor, size: 5.h):  appButton(onTap: () async {
                  var check = await _registerContoller.checkOTPFromFirestore(email,password);
                 if(check){
                   Get.offAllNamed(Routes.navbarRoots);
                 }else{
                   print("False");
                 }
                  // _registerContoller.getCombinedOtp();
                },text: "Submit"),
              ),
              5.h.addHSpace(),
            ],
          ),
        ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 4.h,
                  ),
                ),
              ),
            ),
            5.h.addHSpace(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Verfication code"
                      .boldRoboto(fontSize: 32, fontColor: Colors.black),
                  "we have sent the code verfication to"
                      .mediumReadex(fontColor: Colors.black38),
                  "${email}"
                      .mediumReadex(fontColor: Colors.black),
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
                            controller: _registerContoller.controllers[index],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        if (!_registerContoller.canResend.value) {
                          return Text('Time Remaining: ${_registerContoller.resendTimeout.value} seconds');
                        } else {
                          return Text("Resend");
                        }
                      }),
                      Obx(() {
                        return ElevatedButton(
                          onPressed: _registerContoller.canResend.value
                              ? () {
                            _registerContoller.startResendTimer(email: email);
                          }
                              : null,
                          child: Text('Resend OTP'),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
