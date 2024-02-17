import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';
import 'orderScreencontroller.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final orderScreenController order =
  Get.put(orderScreenController());
  List<String> services = ["All", "Cleaning", "Repairing", "Painting"];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          radius: 30,
        ),
        onTap: () {

        },
        subtitle: Text("Retting1"),
        title: Text("User${index}"),
        trailing: Text("12/08/2002"),
      );
    },);
  }
}
