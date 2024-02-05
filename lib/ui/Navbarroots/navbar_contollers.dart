import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/HomeScreen/Homescreen.dart';
import 'package:home_hub_services/ui/mesegeScreen/mesegeScreen.dart';
import 'package:home_hub_services/ui/sceduleScreen/sceduleScreen.dart';

import '../SettingScreen/SettingScreen.dart';

class NavbarController extends GetxController{
  RxInt selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    // Mesege Screen
    MessageScreen(),
    //Scedule Screen
    ScheduleScreen(),
    //seting Screen
    SettingScreen(),
  ].obs;

}