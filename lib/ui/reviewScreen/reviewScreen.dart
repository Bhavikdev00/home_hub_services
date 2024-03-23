import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/reviewScreen/review_continer.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(onPressed: () {
              Get.back();
            }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
            title: Text('Reviews',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            floating: true,
            expandedHeight: 150, // Adjust as per your design
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://www.shutterstock.com/image-illustration/testimonials-icon-isolated-on-special-260nw-1149227165.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return ReviewContainer(); // Assuming ReviewContainer is your widget
              },
              childCount: 6, // Change this to your actual number of reviews
            ),
          ),
        ],
      ),
    );
  }
}
