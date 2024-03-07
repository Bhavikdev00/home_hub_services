import 'package:cloud_firestore/cloud_firestore.dart';

class chatRoom{
  final DateTime LastChat;
  final String  firstUid;
  final String secondUid;
  final String docId;
  chatRoom({required this.docId,required this.LastChat, required this.firstUid, required this.secondUid});

  factory chatRoom.fromJson(Map<String, dynamic> json) {
    return chatRoom(
      docId : json["roomId"],
      LastChat: (json['LastChat'] as Timestamp).toDate(),
      firstUid: json['firstUid'],
      secondUid: json['secondUid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "roomId" :this.docId,
      'LastChat': Timestamp.fromDate(LastChat),
      "firstUid": this.firstUid,
      "secondUid": this.secondUid,
    };
  }
}

