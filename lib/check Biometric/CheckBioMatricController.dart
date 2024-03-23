
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../utils/app_routes.dart';
import 'auth_api.dart';

class CheckBioMetricController extends GetxController {
  bool isAuthenticate = false;

  checkAuth(BuildContext context) async {
    isAuthenticate = await LocalAuthApi.authenticate(context);
    if (isAuthenticate == true) {
      Get.offNamed(Routes.navbarRoots);
    }
  }
}