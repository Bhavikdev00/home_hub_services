import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/getstorage/StorageClass.dart';

import '../../ModelClasses/servicesProvider.dart';
import '../../utils/app_routes.dart';
import '../HomeScreen/authservices.dart';

class SettingsControllers extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  StorageService _storageService = StorageService();
  var isLoading = true.obs;
   Rx<ServicesData?> servicesData = Rx<ServicesData?>(null);

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    String? uid = _auth?.currentUser!.uid;
    // print(_auth?.uid);
    await FirebaseFirestore
        .instance
        .collection('service_providers')
        .where('Uid', isEqualTo: uid)
        .limit(1).snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.docs.isNotEmpty){
            servicesData.value  = ServicesData.formMap(snapshot.docs.first.data());
          }
    });
    isLoading.value = false;
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _storageService.loginStatusCheck(false);
      Get.offAllNamed(Routes.loginScreen);// Replace '/login' with your login route
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}
