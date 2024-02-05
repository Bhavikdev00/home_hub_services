import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/getstorage/StorageClass.dart';

import '../../utils/app_routes.dart';
import '../HomeScreen/authservices.dart';

class SettingsControllers extends GetxController {
  RxBool isLoading = false.obs;
  final AuthService _authService = Get.put(AuthService());
  StorageService _storageService = StorageService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxString displayName = ''.obs;
  RxString services = ''.obs;
  RxString Name = ''.obs;
  RxString NetworkImages = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    String? uid = _auth?.currentUser!.uid;
    print("its a Call");
    // print(_auth?.uid);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('ServiceProviderProfileInfo')
        .where('Uid', isEqualTo: uid)
        .limit(1)
        .get();
    Map<String, dynamic> documentData = querySnapshot.docs.first.data();
    String fieldValue = documentData['services'];
    String fname = documentData['fname'];
    String lname = documentData['lname'];
    String images = documentData['Images'];
    NetworkImages.value = images;
    Name.value = "${fname} ${lname}";
    services.value = fieldValue;
    isLoading.value = false;
    update();
  }


  getImageLoad(String images){
    try{


    }catch(e){
      print("Image Call Error");
    }
  }



  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _storageService.loginStatusCheck(false);
      // Navigate to the login screen or wherever you want after logout
      Get.offAllNamed(Routes.loginScreen);// Replace '/login' with your login route
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}
