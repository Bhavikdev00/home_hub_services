import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/ModelClasses/GDPDATA.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../ModelClasses/OrderResModel.dart';
import '../../ModelClasses/service.dart';
import '../../ModelClasses/servicesProvider.dart';
import '../../getstorage/StorageClass.dart';

class HomeScreenController extends GetxController {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    //
    loadUserData();
    requestNotificationPermission();
  }
RxInt totalAmount = 0.obs;
  RxList<ServicesData> serviceData = <ServicesData>[].obs;
  Rx<User?> user = Rx<User?>(null);
  RxString displayName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool LoadImages = true.obs;
  RxList<ServiceResponseModel> services = <ServiceResponseModel>[].obs;
  RxList<OrderResModel> order = <OrderResModel>[].obs;
  RxList<OrderResModel> pendings = <OrderResModel>[].obs;

  int orderData = 0;
  int pending = 0;
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
      await getOrderDetails();
      DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('service_providers').doc(uid);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
      if (snapshot.exists) {
        String fname = snapshot.data()?['fname'];
        String lname = snapshot.data()?['lname'];
        String FullName = fname + " " + lname;
        _storageService.UpdateUserName(FullName);
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
        update();
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

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.request();

    if (status.isGranted) {
      print("Permission  accepted ");

      // Permission is granted
    } else if (status.isDenied) {
      print("Permission  is Denied  ");
      // Permission is denied
    } else if (status.isPermanentlyDenied) {

      // Permission is permanently denied, navigate to app settings
      openAppSettings();
    }
  }

   getOrderDetails() async {
    String uid = _storageService.getUserid();
    CollectionReference orderCollection = FirebaseFirestore.instance.collection("Orders");
    orderCollection
        .where("serviceProviderId", isEqualTo: uid)
        .snapshots() // Listen to real-time updates
        .listen((QuerySnapshot orderData) {
      order.clear(); // Clear the existing list of orders
      for (var object in orderData.docs) {
        OrderResModel orderResModel =
        OrderResModel.fromJson(object.data() as Map<String, dynamic>);
        order.add(orderResModel);
        calculateAmount(orderResModel.amount);// Add each order to the list
      }
      panddingData(order); // Call a method to handle pending data (assuming this method exists)
      // Notify listeners about changes
    });
  }

  void panddingData(RxList<OrderResModel> order) {
    pendings.value = order.where((check) => check.status == "Pending").toList();
  }

  void calculateAmount(int? amount) {
    totalAmount.value += amount!;
  }



}
