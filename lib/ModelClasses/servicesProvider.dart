class ServicesData{
  String? Uid;
  String fname;
  String lname;
  String? Did;
  String Images;
  String email;
  String contectnumber;
  String contectNumber2;
  String address;
  String? status;
  String? services;
  String? password;
  String? useraadharcard;
  String? fcmToken;
  String? uipId;
  int? clicks;
  ServicesData(
      { this.Uid,
        this.fcmToken,
        required this.fname,
        required this.lname,
        this.Did,
        this.status,
         this.clicks,
      required this.Images,
      required this.email,
      required this.contectnumber,
      required this.contectNumber2,
      required this.address,
        this.uipId,
       this.services,
         this.useraadharcard,
       this.password});

  Map<String, dynamic> tomap() {
    return {
      "clicks" : this.clicks,
      "upiId" : this.uipId,
      "fcmToken" : this.fcmToken,
      "Uid": this.Uid,
      "Images": this.Images,
      "email": this.email,
      "contact": this.contectnumber,
      "status": this.status,
      "did" : this.Did,
      "contact(optional)": this.contectNumber2,
      "address": this.address,
      "services": this.services,
      "password" : this.password,
      "fname" : this.fname,
      "lname" : this.lname,
      "useraadharcard" : this.useraadharcard,
    };
  }

  factory ServicesData.formMap(Map<String, dynamic> map) {
    return ServicesData(
      clicks: map["clicks"] ?? 0,
      uipId: map["upiId"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
      useraadharcard: map["useraadharcard"] ?? "",
      Uid: map["Uid"] ?? "",
      fname: map["fname"]?? "",
      Did: map["did"] ?? "",
      lname: map["lname"] ?? "",
      Images: map["Images"] ?? "",
      status: map["status"] ?? "",
      email: map["email"] ?? "",
      contectnumber: map["contact"] ?? "",
      contectNumber2: map["contact(optional)"] ?? "",
      address: map["address"] ?? "",
      services: map["services"] ?? "",
      password: map["password"] ?? "",
    );
  }
//
}