import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/constraint/app_color.dart';

import 'package:home_hub_services/ui/HomeScreen/chart_container.dart';
import 'package:home_hub_services/ui/HomeScreen/homescreenController.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:sizer/sizer.dart';

import '../../drawerscreens/addservices/Addservices.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeScreenController _homeScreenController = Get.put(HomeScreenController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:  Drawer(
        child: Column(
          children: <Widget>[
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
            ExpansionTile(
              leading: Icon(Icons.category),
              title: Text('Services Management'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.design_services),
                    title: const Text('Add Services'),
                    onTap: () {
                      Get.to(AddServices());
                      // Handle category 1 tap
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.delete),
                    title:const  Text('Delete Services'),
                    onTap: () {
                      // Handle category 1 tap
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.update),
                    title:const  Text('Update Services'),
                    onTap: () {
                      // Handle category 1 tap
                    },
                  ),
                ),
                // Add more list tiles for other categories
              ],
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit app'),
              onTap: () {
                exitApp();
              },
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
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(controller.userData.value.Images),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
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
                                            Text("Increase 20%",style: TextStyle(fontSize: 17),)
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
                                            Text("Increase 20%",style: TextStyle(fontSize: 17),)
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
                                            Text("Increase 20%",style: TextStyle(fontSize: 17),)
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
                                            Text("Increase 20%",style: TextStyle(fontSize: 17),)
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
                    1.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Services".mediumReadex(
                            fontSize: 20, fontColor: Colors.black),
                        Icon(Icons.more_vert, color: Colors.black)
                      ],
                    ),
                    1.h.addHSpace(),
                    CarouselSlider(
                      options: CarouselOptions(height: 22.h, autoPlay: true),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/tree-736885_1280.jpg"),
                                    fit: BoxFit
                                        .fill, // Change BoxFit.cover to BoxFit.fill
                                  ),
                                  border:
                                  Border.all(color: Colors.black38, width: 2),
                                ),
                              ).paddingSymmetric(horizontal: 10),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    2.h.addHSpace(),


                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void exitApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      exit(0); // Exit app on mobile platforms
    } else {
      // Handle other platforms if needed
    }
  }
}

class ExtensionListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTap;

  const ExtensionListTile({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.contentPadding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }
}
