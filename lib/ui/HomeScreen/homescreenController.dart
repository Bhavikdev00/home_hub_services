import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/ModelClasses/GDPDATA.dart';
import '../../ModelClasses/service.dart';
import '../../ModelClasses/servicesProvider.dart';
import '../../getstorage/StorageClass.dart';
import 'authservices.dart';

class HomeScreenController extends GetxController {
  final StorageService _storageService = StorageService();
  final AuthService _authService = Get.put(AuthService());

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  RxList<ServicesData> serviceData = <ServicesData>[].obs;
  Rx<User?> user = Rx<User?>(null);
  RxString displayName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool LoadImages = true.obs;
  RxList<Service> services = <Service>[].obs;
  Rx<ServicesData> userData = ServicesData(
          Uid: "",
          fname: "",
          lname: "",
          Images: "",
          email: "",
          contectnumber: "",
          contectNumber2: "",
          address: "",
          services: "",
          password: "",
          useraadharcard: "")
      .obs;

  User? get currentUser => user.value;

  void loadUserData() async {
    isLoading.value = true;

    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      await getServices(uid);

      DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('service_providers').doc(uid);

      // Fetch initial user data
      DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();

      if (snapshot.exists) {
        userData.value = ServicesData.formMap(snapshot.data()!);
        print("Success");
      } else {
        print("Data is empty");
      }

      // Listen for live updates
      userRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          userData.value = ServicesData.formMap(snapshot.data()!);
          print("Live update received");
        } else {
          print("Data is empty");
        }
      });
    } else {
      print("User is null");
    }

    isLoading.value = false;
  }

  List<GDPData> getchatData() {
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

  Future<void> getServices(String uid) async {
    CollectionReference servicesCollection = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)')
        .doc(uid)
        .collection('services');
    servicesCollection.snapshots().listen((QuerySnapshot<Object?> event) {
      services.clear();
      event.docs.forEach((doc) {
        if (doc.data() != null) {
          services.add(Service.fromMap(doc.data()! as Map<String, dynamic>));
        }
      });
    });
    QuerySnapshot<Map<String, dynamic>>? initialSnapshot =
        (await servicesCollection.get())
            as QuerySnapshot<Map<String, dynamic>>?;
    services.clear();

    // Populate services list with initial data
    initialSnapshot!.docs.forEach((doc) {
      services.add(Service.fromMap(doc.data()));
    });
  }
}
