import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class orderScreenController extends GetxController {
  TextEditingController searchController = TextEditingController();
  int popularServicesIndex = 0;

  bool isSaved = false;
  void setPopularServicesIndex({required int index}) {
    popularServicesIndex = index;
    update();
  }

  void setSavedValue({required bool value}) {
    isSaved = value;
    update();
  }
}