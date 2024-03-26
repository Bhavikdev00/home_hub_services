import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../ModelClasses/messeges.dart';
import '../../ModelClasses/user.dart';
import '../../constraint/app_color.dart';
import 'chatscreen.dart';
import 'mesegesController.dart'; // Assuming you have your controller in this file

class MessageScreen extends StatelessWidget {
  final MessegeController chatScreenController = Get.put(MessegeController());

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
                          onChanged: (value) {
                            if (value.length >= 1) {
                              chatScreenController.getSearchMesseges(searchValue: value);
                              chatScreenController.setSearchValue(value: true);
                            } else {
                              chatScreenController.setSearchValue(value: false);
                            }
                          },
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
            SizedBox(height: 30),
            Expanded(
              child: GetBuilder<MessegeController>(
                builder:(_) {
                  List<UserData> user = [];
                  List<ChatRoomResModel> chatdata = [];
                  if (_.isSearch.value == true) {
                    user.clear();
                    chatdata.clear();
                    user = _.searchUserData.value;
                    chatdata = _.searchChatRooms;
                  } else {
                    user.clear();
                    chatdata.clear();
                    user = _.userDatas;
                    chatdata = _.chatrooms;
                  }
                  if(_.isLoading.value){
                    return Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: appColor,
                        size: 40,
                      ),
                    );
                  }else {
                    if(_.isSearch.value){
                      return user.isEmpty ?  Center(
                          child: "Opps! No Data Found"
                              .boldOpenSans(fontColor: Colors.black)) : ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                              height:
                              10); // Adjust the spacing between list items
                        },
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          String hour = chatdata[index].lastChatTime.hour.toString();
                          String minits = chatdata[index].lastChatTime.minute.toString();
                          return   Container(
                            child: ListTile(
                              onTap: () {
                                Get.to(ChatScreen(chatdata[index],
                                    user[index], _.roomId[index]));
                              },
                              leading: Container(
                                height: 90,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child:user[index].profileImage == ""
                                      ? Image.asset(
                                    "assets/images/profile_image.jpg",
                                    fit: BoxFit.fill,
                                  )
                                      : CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return LoadingAnimationWidget
                                          .hexagonDots(
                                          color: appColor, size: 3.h);
                                    },
                                    fit: BoxFit.fill,
                                    imageUrl:
                                    _.userDatas[index].profileImage,
                                  ),
                                ),
                              ),
                              title: Text(
                                "${user[index].firstName} ${user[index].lastName}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${chatdata[index].LastChat}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              trailing: Text(
                                "$hour : $minits",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                              height:
                              10); // Adjust the spacing between list items
                        },
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _.chatrooms.length,
                        itemBuilder: (context, index) {
                          String hour = _.chatrooms[index].lastChatTime.hour.toString();
                          String minits = _.chatrooms[index].lastChatTime.minute.toString();
                          return user.isEmpty ? Container(
                            child: Text("Not a Chat"),
                          ) :Container(
                            child: ListTile(
                              onTap: () {
                                Get.to(ChatScreen(_.chatrooms[index],
                                    _.userDatas[index], _.roomId[index]));
                              },
                              leading: Container(
                                height: 90,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _.userDatas[index].profileImage == ""
                                      ? Image.asset(
                                    "assets/images/profile_image.jpg",
                                    fit: BoxFit.fill,
                                  )
                                      : CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return LoadingAnimationWidget
                                          .hexagonDots(
                                          color: appColor, size: 3.h);
                                    },
                                    fit: BoxFit.fill,
                                    imageUrl:
                                    _.userDatas[index].profileImage,
                                  ),
                                ),
                              ),
                              title: Text(
                                "${_.userDatas[index].firstName} ${_.userDatas[index].lastName}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${_.chatrooms[index].LastChat}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              trailing: Text(
                                "$hour : $minits",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
            )
            )
          ],
        ),
      ),
    );
  }
}
