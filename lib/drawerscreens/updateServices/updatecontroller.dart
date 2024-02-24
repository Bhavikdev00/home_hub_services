import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../ModelClasses/service.dart';

class UpdateController extends GetxController {
  RxBool showContent = false.obs;
  RxString userid = RxString('');
  RxBool LoadingServices = false.obs;
  Rx<File?> imageFile = Rx<File?>(null);
  final RxList<File> _images = <File>[].obs;

  List<File> get imagesPick => _images;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategory();
  }

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

  var Services = Rx<String?>(null);
  var category = Rx<String?>(null);

  void setSelectedService(String? service) {
    Services.value = service;
    update();
  }

  void setSelectedCategory(String? service) {
    category.value = service;
    update();
  }

  RxList<String> selectServices = <String>[].obs;
  RxList<String> selectedCategory = <String>[].obs;

  Future<void> loadCategory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("servicesInfo").get();
    CollectionReference servicesCollection = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)')
        .doc(userid.value)
        .collection('services');

    try {
      QuerySnapshot querySnapshot = await servicesCollection.get();
      querySnapshot.docs.forEach((doc) {
        selectedCategory.add(doc["servicesName"]);
      });
    } catch (e) {
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

// Get The Data From Firebase FIrestore
  Future<List<Service>> getData() async {
    LoadingServices.value = true;
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)')
        .doc(userid.value)
        .collection('services');

    if (Services.value != null) {
      // Ensure 'CategoryName' is the correct field name in your Firestore documents
      query = query
          .where('CategoryName', isEqualTo: Services.value)
          .where("servicesName", isEqualTo: category.value);
    }
    List<Service> services = <Service>[];
    var check = await query.get();
    for (var element in check.docs) {
      services.add(Service.fromMap(element.data()));
    }
    LoadingServices.value = false;
    return services;
  }

  updateImages(ImageSource source) async {
    await _pickTheImages(source);
    update();
  }

  Future<void> _pickTheImages(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      update();
    }
  }

  Future<void> pickPosterImages() async {
    List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null) {
      imagesPick.addAll(pickedImages.map((image) => File(image.path)));
    }
  }

  Future<bool> updatedData(
      {required String desc,
      required String sname,
      required int price,
      required String serviceId}) async {
    // List<String> images = await ();
   try{
     List<String> images =await updateImagesData();
     final servicesUpdate = await FirebaseFirestore.instance
         .collection("Services-Provider(Provider)")
         .doc(userid.value)
         .collection("services");
     // await servicesUpdate.doc(serviceId).update({
     //   "servicesName": sname,
     //   "images" : images,
     //   "price" : price,
     //   "description" : desc,
     // });
     print(serviceId);
     return true;
   }catch(e){
     print(e.toString());
     return false;
   }
  }

  Future<List<String>> updateImagesData() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> downloadUrls = [];
    for (var image in imagesPick) {
      String extentions = extension(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + extentions;
      Reference ref = storage.ref().child('Images').child(fileName);
      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }
}
