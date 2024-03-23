import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_services/ModelClasses/OrderResModel.dart';
import 'package:home_hub_services/ModelClasses/user.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatelessWidget {

  UserData userData;
  OrderResModel filterData;
  OrderDetailsScreen(this.userData,this.filterData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.h.addHSpace(),
              Center(
                child: Container(
                  height: 13.h,
                  width: 13.h,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: userData.profileImage ?? "")),
                ),
              ),
              2.h.addHSpace(),
              Center(
                child: "${userData.firstName} ${userData.lastName}"
                    .boldOpenSans(fontSize: 13.sp, fontColor: Colors.black),
              ),
              5.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Email : "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      "${userData.email}"
                          .semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Contact : ".boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      "${userData.phoneNumber}".semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Address :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Expanded(
                        child: "${userData.address}".semiOpenSans(
                            fontSize: 12.sp,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Service :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      "${filterData.servicesName}".semiOpenSans(
                          fontSize: 12.sp,
                          textOverflow: TextOverflow.ellipsis,
                          fontColor: Colors.black),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Payment Status :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Expanded(
                        child: "${filterData.paymentStatus}".semiOpenSans(
                            fontSize: 12.sp,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              filterData.status == "Pending" ?  Row(
                children: [
                  Expanded(
                      child: appButton(
                          onTap: () {

                          },
                          bordorColor: Colors.red,
                          color: Colors.transparent,
                          text: "Delete Order History",
                          borderRadius: 12,
                          fontSize: 12.sp,
                          fontColor: Colors.red)),
                  2.w.addWSpace(),
                  Expanded(
                      child: appButton(
                          onTap: () {
                                  
                          },
                          text: "Back",
                          color: Colors.green,
                          fontSize: 12.sp,
                          borderRadius: 12,
                          fontColor: Colors.white))
                ],
              ) : Row(
                children: [
                  Expanded(
                      child: appButton(
                          onTap: () {

                          },
                          bordorColor: Colors.red,
                          color: Colors.transparent,
                          text: "Order Complete",
                          borderRadius: 12,
                          fontSize: 12.sp,
                          fontColor: Colors.red)),
                  2.w.addWSpace(),
                  Expanded(
                      child: appButton(
                          onTap: () {

                          },
                          text: "Delete",
                          color: Colors.green,
                          fontSize: 12.sp,
                          borderRadius: 12,
                          fontColor: Colors.white))
                ],
              ),
              1.5.h.addHSpace(),
              2.h.addHSpace(),
              const Spacer(),
            ],
          ).paddingSymmetric(horizontal: 2.w),
        ),
    );
  }
}
