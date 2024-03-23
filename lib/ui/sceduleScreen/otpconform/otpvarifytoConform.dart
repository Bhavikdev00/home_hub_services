import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/OrderResModel.dart';
import 'package:home_hub_services/ModelClasses/user.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'otpvarifyconfrom_controller.dart';

class OtpVarification extends StatefulWidget {
  OrderResModel order;
  UserData user;

  OtpVarification(this.order,this.user);

  @override
  State<OtpVarification> createState() => _OtpVarificationState();
}

class _OtpVarificationState extends State<OtpVarification>  {


  OtpVarificationConntroller conntroller = Get.put(OtpVarificationConntroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OtpVarificationConntroller>(builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                8.h.addHSpace(),
                Lottie.asset("assets/lottie/otp.json"),
                "Please check your email and enter the 6-digit OTP below."
                    .semiOpenSans(
                    fontColor: Colors.black,
                    textAlign: TextAlign.center,
                    fontSize: 12.sp),
                7.h.addHSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextFormField(
                        controller: controller.otpControllers[index],
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length == 1) {
                            controller.isOtpFielled();
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: "0",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    );
                  }),
                ),
                3.h.addHSpace(),
                TextButton(
                  onPressed: controller.enableResend == true
                      ? () {
                    controller.resendOtp(email: widget.user.email);
                  }
                      : () {},
                  child: Text(controller.enableResend == true
                      ? "Resend OTP"
                      : "Resend in ${controller.start} seconds"),
                ),
                20.h.addHSpace(),
                controller.otpfilled == true
                    ? appButton(
                    onTap: () async {
                      String filledOtp = controller.getOtpFromScreen();
                      bool result = await controller.varifyOtp(filledOtp);
                      if (result) {
                        await controller.comp(widget.order,widget.user);
                        Get.snackbar("Service", "Completed Thank You");
                        Get.back();
                      }
                    },
                    fontSize: 12.sp,
                    fontColor: Colors.white,
                    text: "Submit")
                    : const SizedBox(),
                10.h.addHSpace(),
              ],
            ).paddingSymmetric(horizontal: 2.w),
          );
      },),
    );
  }
}
