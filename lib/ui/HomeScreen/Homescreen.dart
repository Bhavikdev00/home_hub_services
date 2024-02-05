import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/ui/HomeScreen/chart_container.dart';
import 'package:home_hub_services/ui/HomeScreen/homescreenController.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
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
            ListTile(
              onTap: () {

              },
              title: "LogOut".mediumReadex(fontColor: Colors.black),
              leading: Icon(Icons.logout),
              trailing: Icon(Icons.navigate_next),
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
                      children: [
                        Container(

                          height: 13.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              color: Colors.indigoAccent,
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
                                      Text("NEW ORDER",style: TextStyle(fontSize: 16),),
                                      Row(
                                        children: [
                                          
                                        ],
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
