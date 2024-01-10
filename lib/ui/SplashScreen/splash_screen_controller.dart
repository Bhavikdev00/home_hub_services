import 'dart:async';

import 'package:get/get.dart';

import '../../getstorage/StorageClass.dart';
import '../../utils/app_routes.dart';

class SplashScreenController extends GetxController {
  String displayText = '';
  int index = 0;
  final StorageService _storageService = StorageService();
  final String _fullText = 'Help Harbor';

  @override
  void onInit() {
    super.onInit();
    _startTyping();
    _navigate();
  }

  void _navigate() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        if(_storageService.getLoginStatus() || _storageService.getRegisterStatus()){
           Get.offAllNamed(Routes.homeScreen);
        }else{
          Get.offAllNamed(Routes.loginScreen);
        }
      },
    );
  }

  void _startTyping() {
    const typingInterval = Duration(milliseconds: 200);

    Timer.periodic(typingInterval, (Timer timer) {
      if (index < _fullText.length) {
        displayText = _fullText.substring(0, index + 1);
        index++;
        update();
      } else {
        timer.cancel();
      }
    });
  }
}
