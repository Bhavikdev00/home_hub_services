class ServicesData{
  String Uid;
  String? Did;
  String Images;
  String email;
  String contectnumber;
  String contectNumber2;
  String address;
  String services;

  ServicesData(
      {required this.Uid,
      this.Did,
      required this.Images,
      required this.email,
      required this.contectnumber,
      required this.contectNumber2,
      required this.address,
      required this.services});

  Map<String, dynamic> tomap() {
    return {
      "Uid": this.Uid,
      "Did": this.Did,
      "Images": this.Images,
      "email": this.email,
      "contact": this.contectnumber,
      "contact(optional)": this.contectNumber2,
      "address": this.address,
      "services": this.services,
    };
  }

}