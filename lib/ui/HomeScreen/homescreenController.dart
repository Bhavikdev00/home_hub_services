import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/ModelClasses/GDPDATA.dart';
import '../../ModelClasses/service.dart';
import '../../ModelClasses/servicesProvider.dart';
import '../../getstorage/StorageClass.dart';

class HomeScreenController extends GetxController {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    // NotificationService.sendMessage(msg: "Hello",title: "Balaji",receiverFcmToken: "dId5yUQWTFeE0Hs5Djn-rY:APA91bFA-LHfupFhrA8XwZk7rGJc3F48GIZJ6Pjju_9aAZPp0zd4NRMm2zxfGr6CUs1spPkREy0KiJsqzcWTuKzCVga56v74WVQT7Wwu4MnhU4AzJHJDFI6-Kp7KMx5GQYrGeh3AA4wk");
    loadUserData();
  }

  RxList<ServicesData> serviceData = <ServicesData>[].obs;
  Rx<User?> user = Rx<User?>(null);
  RxString displayName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool LoadImages = true.obs;
  RxList<ServiceResponseModel> services = <ServiceResponseModel>[].obs;
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
    _storageService.loginStatusCheck(true);

    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      _storageService.UpdateUserId(uid);
      await getServices();
      DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('service_providers').doc(uid);
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

  Future<void> getServices() async {
    String uid = _storageService.getUserid();
    Query<Map<String, dynamic>> servicesCollection = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)').where("userId",isEqualTo: uid);
    servicesCollection.snapshots().listen((QuerySnapshot<Object?> event) {
      services.clear();
      event.docs.forEach((doc) {
        if (doc.data() != null) {
          services.add(ServiceResponseModel.fromMap(doc.data()! as Map<String, dynamic>));
        }
      });
    });
    QuerySnapshot<Map<String, dynamic>>? initialSnapshot =
    (await servicesCollection.get())
    as QuerySnapshot<Map<String, dynamic>>?;
    services.clear();

    // Populate services list with initial data
    initialSnapshot!.docs.forEach((doc) {
      services.add(ServiceResponseModel.fromMap(doc.data()));
    });
  }
}
