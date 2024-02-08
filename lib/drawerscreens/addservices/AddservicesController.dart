
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:home_hub_services/ModelClasses/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ModelClasses/ScreenData.dart';

class AddServicesController extends GetxController{
  final serviceName = TextEditingController();
  final description = TextEditingController();
  RxString userid = RxString('');
  Rx<File?> imageFile = Rx<File?>(null);
  var selectedServices = Rx<String?>(null);
  RxBool showContent = false.obs;
  RxBool IsLoadding = false.obs;
  final RxList<File> _pickedImages = <File>[].obs;

  List<File> get pickedImages => _pickedImages;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategoryList();
  }

  void setSelectedService(String? service) {
    selectedServices.value = service;
  }
  RxList<String> selectServices = <String>[].obs;
  Future<void> loadCategoryList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("servicesInfo").get();

    print(snapshot.docs.length);
    try {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in snapshot.docs) {
        // Change "fieldName" to the actual field name you want to extract
        String fieldValue = document['ServicesName'];

        // Add the field value to the list
        if (fieldValue != null) {
          selectServices.add(fieldValue);
        }
      }

    } catch (e) {
      print('Error loading category list: $e');
      // Handle the error if necessary
    }
  }
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
  void remove(){
    imageFile.value = null;
    update();
  }

  void toggleContent() {
    showContent.value = !showContent.value;
    update();
  }

  Future<void> pickImages() async {
    List<XFile>? pickedImages =
    await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null) {
      _pickedImages.addAll(pickedImages.map((image) => File(image.path)));
    }
  }
  void Dispose(){
    serviceName.clear();
    imageFile.value = null;
  }


  Future<bool> uploadImagesToFirebase() async {
    try{
      IsLoadding.value = true;
      List<String> downloadUrls = await _uploadImagesToStorage();
      if (downloadUrls.isNotEmpty) {
        await _updateDatabase(downloadUrls);
        clearingData();
      }
      return true;
      IsLoadding.value = false;
    }catch(e){
      return false;
      print(e.toString());
    }finally{
      IsLoadding.value = false;
    }
  }
  Future<List<String>> _uploadImagesToStorage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> downloadUrls = [];

    for (var imageFile in _pickedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('images').child(fileName);

      // Upload image to Firebase Storage
      await ref.putFile(imageFile);

      // Get download URL for the uploaded image
      String downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
       userid.value  = user.uid;
       print(userid.value);
    } else {
      // User is not logged in
      print("Error ");
    }
  }

  _updateDatabase(List<String> downloadUrls) async {
    String userId = userid.value;
    CollectionReference servicesDataProvider = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)');
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String time = formatter.format(now);
    Services services = Services(servicesName: serviceName.text.toString(), CategoryName: selectedServices.value.toString(), CategoryDescription: description.text.toString(), CreatedAt: time, Images: downloadUrls, uid: userId);
    await servicesDataProvider.add(services.toMap());
  }

  void clearingData() {
    imageFile.value = null;
    selectedServices.value = null;
    description.clear();
    _pickedImages.clear();
    showContent.value = false;
    serviceName.clear();
  }
}