import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_services/ModelClasses/OrderResModel.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';

import 'income_screen_controller.dart';

class IncomeScreen extends StatefulWidget {
  final RxList<OrderResModel> order;

  IncomeScreen(this.order);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateAmount();
  }
  final number = TextEditingController();
final globel = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    IncomeController controller = Get.put(IncomeController(widget.order));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All orders",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Total Amount ${totalAmount}",
              style: TextStyle(
                fontSize: 18,
                color: appColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<IncomeController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.order.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage: CachedNetworkImageProvider(
                              controller.user[index].profileImage ?? "",
                            ),
                          ),
                          title: Text(
                            "${controller.user[index].firstName} ${controller.user[index].lastName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "${widget.order[index].paymentStatus}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Price:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              Text(
                                "${widget.order[index].amount}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 5.h,
                    color: appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      // Open bottom sheet on button click
                      openBottomSheet(context,controller);
                    },
                    child: Text(
                      "Withdrawal \$${totalAmount.toString()}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                2.h.addHSpace(),
              ],
            );
          }
        },
      ),
    );
  }

  void calculateAmount() {
    int total = 0;
    for (var order in widget.order) {
      total += order.amount ?? 0;
    }
    setState(() {
      totalAmount = total;
    });
  }

  Future openBottomSheet(BuildContext context, IncomeController controller) {
    final focusNode = FocusNode();
    return Get.bottomSheet(
      Form(
        key: globel,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h, // Specify the height of the IconButton
                child: IconButton(
                  onPressed: () {
                    // Handle IconButton press
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  "Balance :\$${totalAmount}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              1.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  "Enter Amount Request:",  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              1.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: number,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.parse(value) > totalAmount) {
                      return 'Please enter a value less than or equal to the total amount';
                    }
                    return null; // Return null if validation passes
                  },
                  decoration: InputDecoration(
                    hintText: "\$100",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              ),
              1.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MaterialButton(
                  height: 50,
                  color: Colors.red,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  minWidth: double.infinity,
                  child: const Text("Request"),
                  onPressed: () async {
                    if(globel.currentState!.validate()){
                      int amount = int.parse(number.text.trim());
                       await controller.sendMoney(amount);
                       number.clear();
                       Get.back();
                    }
                },),
              )
            ],
          ),
        ),
      ),
    );
  }
}
