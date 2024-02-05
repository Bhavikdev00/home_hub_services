class ServicesData{
  String Uid;
  String fname;
  String lname;
  String? Did;
  String? status;
  String Images;
  String email;
  String contectnumber;
  String contectNumber2;
  String address;
  String services;
  String password;
  String useraadharcard;
  ServicesData(
      {required this.Uid,
        required this.fname,
        required this.lname,
      this.Did,
        this.status,
      required this.Images,
      required this.email,
      required this.contectnumber,
      required this.contectNumber2,
      required this.address,
      required this.services,
        required this.useraadharcard,
      required this.password});

  Map<String, dynamic> tomap() {
    return {
      "Uid": this.Uid,
      "Did": this.Did,
      "Images": this.Images,
      "status" : this.status,
      "email": this.email,
      "contact": this.contectnumber,
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
      useraadharcard: map["useraadharcard"] ?? "",
      Uid: map["Uid"] ?? "",
      fname: map["fname"]?? "",
      lname: map["lname"] ?? "",
      Did: map["Did"] ?? "",
      Images: map["Images"] ?? "",
      status: map["status"],
      email: map["email"] ?? "",
      contectnumber: map["contectnumber"] ?? "",
      contectNumber2: map["contectNumber2"] ?? "",
      address: map["address"] ?? "",
      services: map["services"] ?? "",
      password: map["password"] ?? "",
    );
  }
//
}