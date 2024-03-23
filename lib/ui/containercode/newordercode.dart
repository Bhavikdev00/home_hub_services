import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../ModelClasses/OrderResModel.dart';
import '../../ModelClasses/user.dart';
import '../../getstorage/StorageClass.dart';
import 'newordercodecontroller.dart';
import 'orderDetailsinUser.dart';

class OrderHistory extends StatelessWidget {
  final OrderHistoryController controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OrderHistoryController>(
          builder: (controller) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 20,
                  floating: true,
                  flexibleSpace: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                            child: Text("Order List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                          ),
                        ),
                        IconButton(
                            iconSize: 30,
                            onPressed: () {
                              controller.dateFunction(context);
                        }, icon: Icon(Icons.filter_alt_outlined)),
                        2.w.addWSpace(),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (controller.isFilter.value) {
                        return Column(
                          children: [
                            controller.filterData.isNotEmpty
                                ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                trailing: IconButton(
                                  onPressed: () {
                                    Get.to(OrderDetailsScreen(controller.userData[index],controller.filterData[index]));
                                  },
                                  icon: Icon(Icons.navigate_next_rounded),
                                ),
                                title: Text(
                                    "${controller.userData[index].firstName} ${controller.userData[index].lastName}"),
                                subtitle: Text(
                                    "${controller.filterData[index].completeDate!.day}/${controller.filterData[index].completeDate!.month}/${controller.filterData[index].completeDate!.year}"),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey,
                                  // Add a background color for the avatar
                                  backgroundImage: CachedNetworkImageProvider(
                                    controller.userData[index].profileImage,
                                  ),
                                ),
                              ),
                            )
                                : Text("No User Order",style: TextStyle(fontSize: 20,),),
                            ElevatedButton(
                              onPressed: () {
                                controller.updateFilter(false);
                              },
                              child: Text("Clear All"),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                Get.to(OrderDetailsScreen(controller.userData[index],controller.orderData[index]));
                              },
                              icon: Icon(Icons.navigate_next_rounded),
                            ),
                            title: Text(
                                "${controller.userData[index].firstName} ${controller.userData[index].lastName}"),
                            subtitle: Text(
                                "${controller.orderData[index].completeDate!.day}/${controller.orderData[index].completeDate!.month}/${controller.orderData[index].completeDate!.year}"),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              // Add a background color for the avatar
                              backgroundImage: CachedNetworkImageProvider(
                                controller.userData[index].profileImage,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    childCount: controller.userData.length,
                  ),
                )

              ],
            );
          },
        ),
      ),
    );
  }
}
