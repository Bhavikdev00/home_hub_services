import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/reviewScreen/review_continer.dart';
import 'package:home_hub_services/ui/reviewScreen/revire_screen_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';

class ReviewScreen extends StatelessWidget {
   ReviewScreen({Key? key});
   ReviewController reviewController = Get.put(ReviewController());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  GetBuilder<ReviewController>(
        builder: (controller) {
          if(controller.isLoadding){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
                ],
              ),
            );
          }else{
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(onPressed: () {
                    Get.back();
                  }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                  title: Text('Reviews',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  floating: true,
                  expandedHeight: 150, // Adjust as per your design
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/rev.jpg',fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return ReviewContainer(controller.reviewsList[index],controller.userDataList[index]); // Assuming ReviewContainer is your widget
                    },
                    childCount: controller.userDataList.length, // Change this to your actual number of reviews
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
