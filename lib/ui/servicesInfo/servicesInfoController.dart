import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/servicesInfo/review.dart';

import 'orderScreen.dart';

class ServiceInfoController extends GetxController{
  int buttonindex = 0;
  List<String> items = [
    "Order",
    "Review"
  ];
  List<String> icons = [
    "assets/images/svg/order.svg",
    "assets/images/svg/review.svg"
  ];


  List<Widget> check = [
    OrderScreen(),
    Review(),
  ];
  int current = 0;
  PageController pageController = PageController(initialPage: 0);

  void updateIndex(int index){
    buttonindex = index;
    update();
  }


}