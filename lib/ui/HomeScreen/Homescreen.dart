import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/ui/HomeScreen/chart_container.dart';
import 'package:home_hub_services/ui/HomeScreen/homescreenController.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeScreenController _homeScreenController = Get.put(HomeScreenController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Obx(
                    () {
                  print(_homeScreenController.userData.value.Images);
                  return ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _homeScreenController.userData.value.Images,
                      fit: BoxFit.cover,
                      width: 130.0,
                      // Set the width and height to create a perfect circle
                      height: 50.0,
                      placeholder: (context, url) => LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              onTap: () {},
              title: "Add Services".mediumReadex(fontColor: Colors.black),
              leading: Icon(Icons.design_services),
              trailing: Icon(Icons.navigate_next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SafeArea(
          child: GetBuilder<HomeScreenController>(
            builder: (controller) {
              return controller.isLoading.value ?  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
                    ),
                  ],
                ),
              ): SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: CachedNetworkImage(
                              imageUrl: controller.userData.value.Images,
                              placeholder: (context, url) {
                                return LoadingAnimationWidget.hexagonDots(color: appColor, size: 2.h);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            // Adjust vertical padding as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    "Good Morning".mediumReadex(
                                      fontColor: Colors.black38,
                                      fontSize: 13,
                                    ),
                                    Image.asset(
                                      "assets/images/hello.png",
                                      scale: 13,
                                      color: Colors.yellow.shade800,
                                    ),
                                  ],
                                ),
                                "${controller.userData.value.fname} ${controller.userData.value.lname}".mediumRoboto(
                                  fontColor: Colors.black,
                                  fontSize: 23,
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomRoundedIcons(
                          iconData: Icons.notification_important,
                          onPress: () {},
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: ChartContainer(
                              chartColor: Colors.green,
                              chartValue: "+10%",
                              title: "Income",
                              value: "10,000"),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          child: ChartContainer(
                              chartColor: Colors.red,
                              chartValue: "-5%",
                              title: "Order",
                              value: "10"),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 15),
                    1.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 15.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              color: Colors.green.shade300,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text("201",style: TextStyle(fontSize: 23,color: Colors.white),),
                                      0.3.h.addHSpace(),
                                      Text("NEW ORDER",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/images/increase.png",scale: 16,),
                                            Text("Increase 20%",style: TextStyle(fontSize: 20),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 15.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("201",style: TextStyle(fontSize: 23,color: Colors.white),),
                                      0.3.h.addHSpace(),
                                      Text("Pandding",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/images/increase.png",scale: 16,),
                                            Text("Increase 20%",style: TextStyle(fontSize: 20),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),

                          ),
                        )
                      ],
                    ),
                    2.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 15.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("201",style: TextStyle(fontSize: 23,color: Colors.white),),
                                      0.3.h.addHSpace(),
                                      Text("Watching",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/images/increase.png",scale: 16,),
                                            Text("Increase 20%",style: TextStyle(fontSize: 20),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 15.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("201",style: TextStyle(fontSize: 23,color: Colors.white),),
                                      0.3.h.addHSpace(),
                                      Text("Total User",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/images/increase.png",scale: 16,),
                                            Text("Increase 20%",style: TextStyle(fontSize: 20),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),

                          ),
                        )
                      ],
                    ),



                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
