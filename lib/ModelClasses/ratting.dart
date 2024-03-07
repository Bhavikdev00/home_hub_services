class Ratting{
    String? doc_id;
    String userid;
    double rating;
    String? review;
    DateTime createdAt;
    Ratting({this.doc_id, required this.userid, required this.rating, this.review,required this.createdAt});

    factory Ratting.fromJson(Map<String, dynamic> json) {
    return Ratting(
      createdAt: json["createdAt"],
      doc_id: json["doc_id"],
      userid: json["userid"],
      rating: double.parse(json["rating"]),
      review: json["review"],
    );
    }

    Map<String, dynamic> toJson() {
    return {
      "createdAt" : this.createdAt,
      "doc_id": this.doc_id,
      "userid": this.userid,
      "rating": this.rating,
      "review": this.review,
    };
  }

//
}