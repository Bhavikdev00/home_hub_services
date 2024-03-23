class Reviews{
  String uid;
  String did;
  String ratting;
  String Description;
  String userName;
  final DateTime createdAt;

  Reviews(
      {required this.uid,
      required this.did,
      required this.ratting,
      required this.Description,
      required this.userName,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "uid": this.uid,
      "did": this.did,
      "ratting": this.ratting,
      "Description": this.Description,
      "userName": this.userName,
      "createdAt": this.createdAt.toIso8601String(),
    };
  }

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      uid: json["uid"],
      did: json["did"],
      ratting: json["ratting"],
      Description: json["Description"],
      userName: json["userName"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}