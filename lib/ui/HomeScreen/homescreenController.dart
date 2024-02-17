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
  void onInit()  {
    super.onInit();
    _loadUserData();
  }

  RxList<ServicesData> serviceData = <ServicesData>[].obs;
  Rx<User?> user = Rx<User?>(null);
  RxString displayName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
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

  void _setDisplayName(User? user) {
    displayName.value = user?.displayName ?? '';
  }

  void _loadUserData() {
    _storageService.RegisterStatusCheck(false);
    isLoading.value = true;

    // Listen to changes in the authentication state
    ever(_authService.user, (User? user) async {
      if (user != null) {
        String uid = user.uid;
        _setDisplayName(user);
        await getServices(user.uid);
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('service_providers')
                .where('Uid', isEqualTo: uid)
                .limit(1)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          userData!.value =
              ServicesData.formMap(querySnapshot.docs.first.data());
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
    update();
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
  // Future<List<Service>> getServices(String uid) async {
  //   DocumentReference userRef = FirebaseFirestore.instance.collection('Services-Provider(Provider)').doc(uid);
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await userRef
  //       .collection('services')
  //       .get();
  //
  //    List<Service> services = [];
  //   querySnapshot.docs.forEach((doc) {
  //     // Create a Service object from the document data and add it to the list
  //     services.add(Service.fromMap(doc.data()));
  //   });
  //   return services;
  // }
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
    QuerySnapshot<Map<String, dynamic>>? initialSnapshot = (await servicesCollection.get()) as QuerySnapshot<Map<String, dynamic>>?;
    services.clear();

    // Populate services list with initial data
    initialSnapshot!.docs.forEach((doc) {
      services.add(Service.fromMap(doc.data()));
    });
    }
}
