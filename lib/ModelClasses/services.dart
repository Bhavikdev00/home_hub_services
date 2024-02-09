import 'package:cloud_firestore/cloud_firestore.dart';

class Services{
  String servicesName;
  String CategoryName;
  String CategoryDescription;
  String CreatedAt;
  List<String> Images;
  List<String> postedImages;
  String uid;
  String UserName;
  String address;
  String did;
  String contactNumber;
  Services(
      {required this.servicesName,
        required this.address,
        required this.did,
        required this.UserName,
        required this.contactNumber,
      required this.CategoryName,
      required this.CategoryDescription,
      required this.CreatedAt,
        required this.postedImages,
      required this.Images,
      required this.uid});

  Map<String, dynamic> toMap() {
    return {
      "servicesName": this.servicesName,
      "CategoryName": this.CategoryName,
      "CategoryDescription": this.CategoryDescription,
      "CreatedAt": this.CreatedAt,
      "Images": this.Images,
      "uid": this.uid,
      "address" : this.address,
      "number" : this.contactNumber,
      "userName" : this.UserName,
      "did" : this.did,
      "postedImages" : this.postedImages
    };
  }

  // factory Services.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   Map<String, dynamic> data = snapshot.data()!;
  //   return Services(
  //     servicesName: data['servicesName'] ?? '',
  //     CategoryName: data['CategoryName'] ?? '',
  //     CategoryDescription: data['CategoryDescription'] ?? '',
  //     CreatedAt: data['CreatedAt'],
  //     Images: List<String>.from(data['Images']),
  //     uid: data['uid'] ?? '',
  //   );
  // }
//
}