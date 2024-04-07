import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/ModelClasses/messeges.dart';
import 'package:home_hub_services/ModelClasses/user.dart';

import '../../getstorage/StorageClass.dart';
import '../notification_services/notification_service.dart';

class MessegeController extends GetxController {
  final StorageService _storageService = StorageService();

  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  Rx<UserData> userData = UserData(
          address: "",
          email: "",
          fcmToken: "",
          firstName: "",
          lastName: "",
          phoneNumber: "",
          profileImage: "",
          uId: "")
      .obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }


  RxBool isSearch = false.obs;
  RxBool isLoading = true.obs;
  RxList<ChatRoomResModel> chatrooms = <ChatRoomResModel>[].obs;
  RxList<UserData> userDatas = <UserData>[].obs;
  StreamSubscription<QuerySnapshot>? _subscription;
  RxList<String> roomId = <String>[].obs;

  RxList<ChatRoomResModel> searchChatRooms = <ChatRoomResModel>[].obs;
  RxList<UserData> searchUserData = <UserData>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getData() async {
    isLoading.value = true;
    String userid = _storageService.getUserid();
    CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection("chatRoom");
    QuerySnapshot chatRoomData = await chatRoomCollection.where("secondUid", isEqualTo: userid).get();
    print(userid);
    chatrooms.clear();
    userDatas.clear();
    roomId.clear();
    for (var element in chatRoomData.docs) {
      roomId.add(element["roomId"]);
      ChatRoomResModel chatRooms = ChatRoomResModel.fromJson(element.data() as Map<String, dynamic>);
      chatrooms.add(chatRooms);
      print(chatRooms.firstUid);
      UserData userData = await getUserData(UserId: chatRooms.firstUid);
      userDatas.add(userData);
    }

    isLoading.value = false;
    update();

    print(chatrooms.length);
    print(userDatas.length);
  }

  void select(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        initialDate: selectedDate.value);
    if (picked != null && picked != selectedDate) {
      selectedDate.value = picked;
    }
    update();
  }

  Future<bool> sendTheOffers(DateTime date, String price, String description,
      String docId, String category, String token, String Sname) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime selected = selectedDate.value;
      Duration positiveDifference = selected.difference(currentDate);
      // int daysDifference = positiveDifference.inDays.abs();
      Map<String, dynamic> message = {
        "sendBy": _storageService.getUserid(),
        "price": int.parse(price),
        "description": description,
        "sId": category,
        "daysToWork": Timestamp.fromDate(selected),
        "msgType": "offers",
        "status": "pending",
        "service_name": Sname,
        "messageId": null,
        "createdAt": DateTime.now(),
      };
      String name = _storageService.getName();
      DocumentReference documentReference = await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(docId)
          .collection('messages')
          .add(message);

      String messageId = documentReference.id;
      await documentReference.update({'messageId': messageId});
      NotificationService.sendMessage(
        msg: "Offer",
        title: "$name",
        receiverFcmToken: token,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void cleanDateTime() {
    selectedDate.value = DateTime.now();
  }

  getUserData({required String UserId}) async {
    CollectionReference serviceProviderUserCollection =
        firestore.collection("User");
    QuerySnapshot userData = await serviceProviderUserCollection
        .where("uId", isEqualTo: UserId)
        .get();
    if (userData.docs.isNotEmpty) {
      return UserData.fromJson(
          userData.docs.first.data() as Map<String, dynamic>);
    } else {
      return [];
    }
  }

  Future<void> deletedOffer(String mesegeId) async {
     String userid = _storageService.getUserid();
     QuerySnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('chatRoom')
        .where("secondUid", isEqualTo: userid)
        .get();
     for (QueryDocumentSnapshot roomDoc in roomSnapshot.docs) {
       // Get the document ID
       String roomId = roomDoc.id;
       // Now you can access the subcollection using the obtained room ID
       DocumentReference messageRef = FirebaseFirestore.instance
           .collection('chatRoom')
           .doc(roomId)
           .collection('messages')
           .doc(mesegeId);
       await messageRef.delete();
     }
  }




  getSearchMesseges({required String searchValue}) {
    searchChatRooms.clear();
    searchUserData.clear();
    for(int i=0;i<chatrooms.length;i++){
      if(userDatas[i].firstName.toLowerCase().contains(searchValue) || userDatas[i].lastName.toLowerCase().contains(searchValue)){
        searchChatRooms.add(chatrooms[i]);
        searchUserData.add(userDatas[i]);
      }
    }
  }

  void setSearchValue({required bool value}) {
    isSearch.value = value;
    update();
  }
}
