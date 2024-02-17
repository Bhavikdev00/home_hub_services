
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/service.dart';

class DeleteServicesController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategory();
  }
  RxList<Service> services = <Service>[].obs;

  var categoryServices = Rx<String?>(null);
  var selectedCategorys = Rx<String?>(null);
  RxString userid = RxString('');

  void setSelectedService(String? service) {
    categoryServices.value = service;
    update();
  }
  void setSelectedCategory(String? service) {
    selectedCategorys.value = service;
    update();
  }
  RxList<String> selectServices = <String>[].obs;
  RxList<String> selectedCategory = <String>[].obs;
  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      userid.value = user.uid;
    } else {
      // User is not logged in
      print("Error ");
    }
  }

  Future<void> loadCategory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance.collection("servicesInfo").get();
    CollectionReference servicesCollection = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)')
        .doc(userid.value)
        .collection('services');

    try{
      QuerySnapshot querySnapshot = await servicesCollection.get();
      querySnapshot.docs.forEach((doc) {
        selectedCategory.add(doc["servicesName"]);
      });
    }catch(e){
      print("The Error Is $e");
    }
    for (QueryDocumentSnapshot<Map<String, dynamic>> document
    in snapshot.docs) {
      // Change "fieldName" to the actual field name you want to extract
      String fieldValue = document['ServicesName'];

      if (fieldValue != null) {
        selectServices.add(fieldValue);
      }
    }
  }
}