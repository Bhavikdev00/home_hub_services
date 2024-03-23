import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../utils/extension.dart';
import 'CheckBioMatricController.dart';

class CheckBiometric extends StatefulWidget {
  const CheckBiometric({super.key});

  @override
  State<CheckBiometric> createState() => _CheckBiometricState();
}

class _CheckBiometricState extends State<CheckBiometric> {
  CheckBioMetricController checkBioMetricController =
  Get.put(CheckBioMetricController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBioMetricController.checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          20.h.addHSpace(),
          Center(
            child: Lottie.asset("assets/lottie/finger.json",
                width: 200, height: 200, frameRate: FrameRate(10000)),
          ),
          Spacer(),
          appButton(
              onTap: () {
                checkBioMetricController.checkAuth(context);
              },
              text: "Authenticate"),
          5.h.addHSpace(),
        ],
      ),
    );
  }
}
