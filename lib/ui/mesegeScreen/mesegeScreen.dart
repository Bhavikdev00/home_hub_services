import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/mesegeScreen/mesegesController.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../constraint/app_color.dart';
import 'chatscreen.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key});

  List<String> images = [
    "doctor1.jpg",
    "doctor2.jpg",
    "doctor3.jpg",
    "doctor4.jpg",
    "doctor1.jpg",
    "doctor2.jpg",
  ];
  MessegeController _messegeController = Get.put(MessegeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(Duration(seconds: 1),() async{
           await _messegeController.loadData();
          },);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Messages",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black12)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Search", border: InputBorder.none),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Color(0xFF7165D6),
                    )
                  ],
                ),
              ),
            ),

            3.h.addHSpace(),
            Obx(
              () =>  Container(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero, // Add this line to remove top padding
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1.h,
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _messegeController.chatRooms.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {

                        Get.to(
                            ChatScreen(_messegeController.chatRooms[index]));
                      },
                      leading: Container(
                        height: 200,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                          _messegeController.userDatas[index].profileImage ==
                              ""
                              ? Image.asset(
                            "assets/images/profile_image.jpg",
                            fit: BoxFit.fill,
                          )
                              : CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: _messegeController
                                  .userDatas[index].profileImage),
                        ),
                      ),
                      title: Text(
                        "${_messegeController.chatRooms[index].firstUid}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Hello, Doctor are you there?",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, color: Colors.black),
                      ),
                      trailing: Text(
                        "${_messegeController.chatRooms[index].LastChat.hour} : ${_messegeController.chatRooms[index].LastChat.minute}",
                        style: TextStyle(
                            fontSize: 15, color: Colors.black54),
                      ),
                    );
                  },
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
