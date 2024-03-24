import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/mesegeScreen/mesegesController.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../constraint/app_color.dart';
import 'chatscreen.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessegeController chatScreenController = Get.put(MessegeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await chatScreenController.getData();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Messages",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
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
            SizedBox(height: 30), // Adjust this spacing as needed
            Expanded(
              child: Obx(
                    () => chatScreenController.isLoading.value
                    ? Center(
                  child: LoadingAnimationWidget.hexagonDots(
                    color: appColor,
                    size: 40, // Adjust the size of the loading animation
                  ),
                )
                    : ListView.separated(
                  padding: EdgeInsets.zero, // Add this line to remove top padding
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1.h,
                    );
                  },
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chatScreenController.chatrooms.length,
                  itemBuilder: (context, index) {

                    String hour = chatScreenController.chatrooms[index].lastChatTime.hour.toString();
                    String minits = chatScreenController.chatrooms[index].lastChatTime.minute.toString();
                    return Container(
                      child: ListTile(
                        onTap: () {
                          Get.to(ChatScreen(chatScreenController.chatrooms[index],chatScreenController.userDatas[index],chatScreenController.roomId[index]));
                        },
                        leading: Container(
                          height: 90,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: chatScreenController.userDatas[index]
                                .profileImage ==
                                ""
                                ? Image.asset(
                              "assets/images/profile_image.jpg",
                              fit: BoxFit.fill,
                            )
                                : CachedNetworkImage(
                              placeholder: (context, url) {
                                return LoadingAnimationWidget.hexagonDots(
                                    color: appColor, size: 3.h);
                              },
                              fit: BoxFit.fill,
                              imageUrl: chatScreenController
                                  .userDatas[index].profileImage,
                            ),
                          ),
                        ),
                        title: Text(
                          "${chatScreenController.userDatas[index].firstName} ${chatScreenController.userDatas[index].lastName}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle:  Text(
                          "${chatScreenController.chatrooms[index].LastChat}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        trailing: Text(
                          "${hour} : ${minits}",
                          style:
                          TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}
