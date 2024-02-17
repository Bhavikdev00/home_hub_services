import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:home_hub_services/drawerscreens/delete/deletedServicescontroller.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';

class deleteServices extends StatelessWidget {
   deleteServices({super.key});
   final deleteController = Get.put(DeleteServicesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Delete Services",style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold),),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            1.h.addHSpace(),
            Text("Selected Services",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w400),),
            1.h.addHSpace(),
            Obx(
                  () => deleteController.categoryServices == null
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
                  value: deleteController.categoryServices.value,
                  hint: const Text('Selected Services'),
                  onChanged: (String? newValue) {
                    deleteController.setSelectedService(newValue);
                  },
                  items: deleteController
                      .selectServices.value
                      .map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                ),
              ),
            ),
            1.h.addHSpace(),
            Text("Selected Category",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w400),),
            1.h.addHSpace(),
            Obx(
                  () => deleteController.selectedCategorys == null
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
                  value: deleteController.selectedCategorys.value,
                  hint: const Text('Selected Category'),
                  onChanged: (String? newValue) {
                    deleteController.setSelectedCategory(newValue);
                  },
                  items: deleteController
                      .selectedCategory
                      .map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
              child: appButton(text: "Delete Services",onTap: (){

              }),
            ),
          ],
        ),
      ),
    );
  }
}
