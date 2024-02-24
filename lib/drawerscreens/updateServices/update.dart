import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/drawerscreens/updateServices/update1.dart';
import 'package:home_hub_services/drawerscreens/updateServices/updatecontroller.dart';
import 'package:sizer/sizer.dart';

import '../../ModelClasses/service.dart';
import '../../utils/extension.dart';

class Update extends StatefulWidget {
  Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final update = Get.put(UpdateController());

  final _globalKey = GlobalKey<FormState>();

  final _SecondKey = GlobalKey<FormState>();

  List<Service> services = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Update Services",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              1.h.addHSpace(),
              Text(
                "Selected Services",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              1.h.addHSpace(),
              Obx(
                () => update.Services == null
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Category'; // Validation message
                            }
                            return null; // Return null if validation succeeds
                          },
                          value: update.Services.value,
                          hint: const Text('Selected Services'),
                          onChanged: (String? newValue) {
                            update.setSelectedService(newValue);
                          },
                          items:
                              update.selectServices.value.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Text(service),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              1.h.addHSpace(),
              Text(
                "Selected Category",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              1.h.addHSpace(),
              Obx(
                () => update.category == null
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Category'; // Validation message
                            }
                            return null; // Return null if validation succeeds
                          },
                          value: update.category.value,
                          hint: const Text('Selected Category'),
                          onChanged: (String? newValue) {
                            update.setSelectedCategory(newValue);
                          },
                          items: update.selectedCategory.map((String service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Text(service),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: appButton(
                    text: "Services Search",
                    onTap: () async {
                      // print(services[0].service_id);

                       services = await update.getData();
                       print(services[0].service_ids);
                      // setState(() {});
                      // if(services.length == 0){
                      //   Get.snackbar("Data Nothing", "Search Again",snackPosition: SnackPosition.BOTTOM,backgroundColor: appColor);
                      // }else{
                      //   Get.to(UpdateData1(services[0]));
                      //   print("Data Hear");
                      // }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
