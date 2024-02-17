

import 'package:home_hub_services/ModelClasses/service.dart';

class Services {
  String servicesName;
  String CreatedAt;
  String uid;
  String UserName;
  Service? categoryName;
  String did;
  String contactNumber;

  Services({required this.servicesName,
    required this.did,
    this.categoryName,
    required this.UserName,
    required this.contactNumber,
    required this.CreatedAt,
    required this.uid});

  Map<String, dynamic> toMap() {
    return {
      "servicesName": this.servicesName,

      "CreatedAt": this.CreatedAt,
      "services" : this.categoryName,
      "uid": this.uid,
      "number": this.contactNumber,
      "userName": this.UserName,
      "did": this.did,
    };
  }

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      categoryName: json['service'] != null ? Service.fromMap(json['service']) : null,
      servicesName: json['servicesName'] ?? "",
      CreatedAt: json['CreatedAt'] ?? "",
      uid: json['uid'] ?? "",
      contactNumber: json['number'] ?? "",
      UserName: json['userName'] ?? "",
      did: json['did'] ?? "",
    );
  }

}
