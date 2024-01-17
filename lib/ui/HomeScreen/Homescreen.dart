import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/GDPDATA.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/constraint/app_string.dart';
import 'package:home_hub_services/getstorage/StorageClass.dart';
import 'package:home_hub_services/ui/HomeScreen/homescreenController.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeScreenController _homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SafeArea(
          child: Obx(
            () => _homeScreenController.isLoading.value
                ? LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h)
                : SingleChildScrollView(
                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return SizedBox(
                                height: 40,
                                width: 40,
                                child: circularImages(
                                  imageUrl: _homeScreenController
                                      .userData!.value.Images,
                                ),
                              );
                            }),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjust vertical padding as needed
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
                                    Obx(
                                          () {
                                        return _homeScreenController.displayName.value.mediumRoboto(
                                          fontColor: Colors.black,
                                          fontSize: 23,
                                        );
                                      },
                                    ),
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
                        2.h.addHSpace(),
                        const Text("Weekly Income",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Container(
                          width: double.infinity, // Set the desired width
                          height: 265, // Set the desired height
                          decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          child: SfCircularChart(
                            legend: const Legend(
                              textStyle: TextStyle(color: Colors.white),
                              isVisible: true,overflowMode: LegendItemOverflowMode.wrap
                            ),
                            series: <CircularSeries>[
                              PieSeries<GDPData, String>(
                                dataSource: _homeScreenController.getchatData(),
                                xValueMapper: (datum, index) => datum.continent,
                                yValueMapper: (datum, index) => datum.Gdp,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              )
                            ],
                          ),
                        ),
                        2.h.addHSpace(),
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 1.h,
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 2)
                                ),
                                height: 10.h,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 35,
                                      
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Parth Vyas"),
                                          1.h.addHSpace(),
                                          const Text("Category Type"),
                                      
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: 110,

                                        child: appButton(onTap: (){},text: "Accept")),
                                    IconButton(onPressed: () {
                                      
                                    }, icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            );
                        },)
                      ],
                    ),
                ),
          ),
        ),
      ),
    );
  }
}
