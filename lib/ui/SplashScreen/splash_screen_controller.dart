import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../getstorage/StorageClass.dart';
import '../../utils/app_routes.dart';
import '../HomeScreen/authservices.dart';

class SplashScreenController extends GetxController {
  final AuthService _authService = Get.put(AuthService());

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
      (value) async {
        if(_authService.currentUser != null){
          Get.offAllNamed(Routes.navbarRoots);
        }else {
          // User is not logged in, navigate to the login screen
          Get.offAllNamed(Routes.navbarRoots);
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

  // Future<bool> checkAdminAllow(String uid) async {
  //   print("Call");
  //   String Userid = uid;
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
  //       .instance
  //       .collection('service_provider_requests')
  //       .where('Uid', isEqualTo: uid)
  //       .limit(1)
  //       .get();
  //   if(querySnapshot.docs.first["status"] == "Rejected"){
  //     return false;
  //   }else{
  //     return true;
  //   }
  // }
}
