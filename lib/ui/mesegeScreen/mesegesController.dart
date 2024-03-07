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
    loadData();
  }
  RxBool IsLoading = false.obs;
  RxList<chatRoom> chatRooms = <chatRoom>[].obs;
  RxList<UserData> userDatas = <UserData>[].obs;
  Future<void> loadData() async {
    IsLoading.value = true;
    String userid = _storageService.getUserid();
    CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection("chatRoom");
    try{
      QuerySnapshot querySnapshot = await chatRoomCollection.where("secondUid",isEqualTo: userid).get();
      chatRooms.clear();
      chatRoom chat = chatRoom(docId: "", LastChat: DateTime.now(), firstUid: "", secondUid: "");
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
         chat=chatRoom.fromJson(doc.data()! as Map<String, dynamic>);
        chatRooms.add(chat);
      }
      CollectionReference userdata = FirebaseFirestore.instance.collection("User");
      QuerySnapshot querySnapshot1 = await userdata.where("uId",isEqualTo: chat.firstUid).get();
      for(QueryDocumentSnapshot doc in querySnapshot1.docs){
        UserData data =UserData.fromJson(doc.data()! as Map<String, dynamic>);
        userDatas.add(data);
      }
      IsLoading.value = false;
    }catch(e){
      IsLoading.value =  false;
      print(e.toString());
    }finally{
      IsLoading.value = false;

    }
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