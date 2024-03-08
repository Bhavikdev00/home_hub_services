import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/messeges.dart';
import 'package:home_hub_services/ModelClasses/user.dart';

import '../../getstorage/StorageClass.dart';

class MessegeController extends GetxController{
  final StorageService _storageService = StorageService();

  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  Rx<UserData> userData = UserData(address: "", email: "", fcmToken: "", firstName: "", lastName: "", phoneNumber: "", profileImage: "", uId: "").obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }
  RxBool isLoading = true.obs;
  RxList<chatRoom> chatrooms = <chatRoom>[].obs;
  RxList<UserData> userDatas = <UserData>[].obs;
  StreamSubscription<QuerySnapshot>? _subscription;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // void GetData(){
  //   isLoading.value = true;
  //   String userid = _storageService.getUserid();
  //   CollectionReference chatRoomCollection = firestore.collection("chatRoom");
  //   Stream<QuerySnapshot> chatRoomData = chatRoomCollection.where("secondUid", isEqualTo: userid).snapshots();
  //   chatrooms.clear();
  //   userDatas.clear();
  //   chatRoomData.listen((event) async {
  //     chatrooms.clear();
  //     userDatas.clear();
  //     for(var element in event.docs){
  //       chatRoom chatRooms = chatRoom.fromJson(element.data() as Map<String, dynamic>);
  //       chatrooms.add(chatRooms);
  //       UserData userData = await getUserData(UserId: chatRooms.firstUid);
  //       userDatas.add(userData);
  //       isLoading.value = false;
  //       update();
  //     }
  //     update();
  //     print(chatrooms.length);
  //     print(userDatas.length);
  //   });
  //
  // }

  Future<void> getData() async {
    isLoading.value = true;
    String userid = _storageService.getUserid();
    CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection("chatRoom");
    QuerySnapshot chatRoomData = await chatRoomCollection.where("secondUid", isEqualTo: userid).get();

    chatrooms.clear();
    userDatas.clear();

    for (var element in chatRoomData.docs) {
      chatRoom chatRooms = chatRoom.fromJson(element.data() as Map<String, dynamic>);
      chatrooms.add(chatRooms);
      UserData userData = await getUserData(UserId: chatRooms.firstUid);
      userDatas.add(userData);
    }

    isLoading.value = false;
    update();

    print(chatrooms.length);
    print(userDatas.length);
  }

  void select(BuildContext context)async{
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        initialDate: selectedDate.value);
    if (picked != null && picked != selectedDate){
      selectedDate.value = picked;


    }
    update();
  }



  Future<bool> sendTheOffers(DateTime date, String price, String description, String docId,String category) async {
    try{

      DateTime currentDate = DateTime.now();
      DateTime  selected = selectedDate.value;
      Duration positiveDifference = selected.difference(currentDate);
      int daysDifference = positiveDifference.inDays.abs();
      Map<String, dynamic> messege = {
        "sendBy": _storageService.getUserid(),
        "price" : int.parse(price),
        "description" : description,
        "service_name" : category,
        "daysToWork" : "${daysDifference} days",
        "msgType": "offers",
        "createdAt": DateTime.now(),
      };
      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(docId)
          .collection('messages')
          .add(messege);
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  void cleanDateTime() {
    selectedDate.value = DateTime.now();
  }

  getUserData({required String UserId}) async {
    CollectionReference serviceProviderUserCollection = firestore.collection("User");
    QuerySnapshot userData = await serviceProviderUserCollection.where("uId",isEqualTo: UserId).get();
    if(userData.docs.isNotEmpty){
      return UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
    }else{
      return [];
    }
  }


  // Future<void> getUSerData(chatRoom chatRoom) async {
  //   DocumentSnapshot  documentReference =await FirebaseFirestore.instance.collection("User").doc(chatRoom.firstUid).get();
  //   // print("user Data ${collectionReference.docs.first.data()}");
  //   if (documentReference.exists) {
  //     userData.value = UserData.fromJson(documentReference.data() as Map<String, dynamic>);
  //   } else {
  //     print('Document does not exist');
  //   }
  // }
}