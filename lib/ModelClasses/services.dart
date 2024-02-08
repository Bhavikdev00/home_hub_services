class Services{
  String servicesName;
  String CategoryName;
  String CategoryDescription;
  String CreatedAt;
  List<String> Images;
  String uid;

  Services(
      {required this.servicesName,
      required this.CategoryName,
      required this.CategoryDescription,
      required this.CreatedAt,
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
    };
  }
}