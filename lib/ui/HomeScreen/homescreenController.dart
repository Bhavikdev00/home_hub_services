import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/GDPDATA.dart';

import '../../ModelClasses/servicesProvider.dart';
import 'authservices.dart';

class HomeScreenController extends GetxController{

  final AuthService _authService = Get.put(AuthService());
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Rx<User?> user = Rx<User?>(null);
  RxString displayName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
  RxBool LoadImages = true.obs;
  Rx<ServicesData> userData = ServicesData(Uid: "", fname: "", lname: "", Images: "", email: "", contectnumber: "", contectNumber2: "", address: "", services: "", password: "",useraadharcard: "").obs;

  User? get currentUser => user.value;
  void _setDisplayName(User? user) {
    displayName.value = user?.displayName ?? '';
    print(user!.displayName);
  }
  void _loadUserData() {
    isLoading.value = true;
    // Listen to changes in the authentication state
    ever(_authService.user, (User? user) async {
      if (user != null) {
        String uid = user.uid;
        print(uid);
        _setDisplayName(user);
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
                .instance
                .collection('service_provider_requests')
                .where('Uid', isEqualTo: uid)
                .limit(1)
                .get();
        if (querySnapshot.docs.isNotEmpty) {
                userData!.value = ServicesData.formMap(querySnapshot.docs.first.data());
                LoadImages.value = false;
                print("Success");
                isLoading(false);
                update();
              } else {
          isLoading(false);
          update();
                print("Data IS Empty");
              }

        // Add logic to fetch and display data based on the user UID
      } else {
        isLoading.value = true;
        print("User is Null");
      }
    });
  }


  List<GDPData> getchatData(){
    final List<GDPData> chatData = [
      GDPData("sunday", 1600),
      GDPData("monday", 1300),
      GDPData("thursday", 200),
      GDPData("wednesday", 10010),
      GDPData("thursday", 1002),
      GDPData("Friday", 1003),
      GDPData("Saturday", 1004),
    ];
    return chatData;

  }




}