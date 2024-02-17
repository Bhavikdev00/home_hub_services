import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_hub_services/ui/servicesInfo/servicesInfoController.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';
import '../../ModelClasses/service.dart';
import '../../constraint/app_color.dart';

class ServicesInfo extends StatelessWidget {
  final Service getdata = Get.arguments;
  final ServiceInfoController homeScreenController = Get.put(ServiceInfoController());

  List<String> services = ["All", "Cleaning", "Repairing", "Painting"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: "${getdata.CategoryName}".boldOpenSans(fontSize: 20),
      ),
      body: SafeArea(
        child: GetBuilder<ServiceInfoController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 30.h,
                      aspectRatio: 0.8,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    items: List.generate(
                        getdata.images.length,
                            (index) => Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20)),
                              child:  ClipRRect( // Use ClipRRect to apply BorderRadius to the child
                                borderRadius: BorderRadius.circular(20), // Adjust the same radius here
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: getdata.images[index],
                                ),
                              ),
                        ).paddingSymmetric(horizontal: 10)),
                  ),
                  1.h.addHSpace(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: "${getdata.name}"
                        .boldOpenSans(fontSize: 17.sp, fontColor: blackColor),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:  BouncingScrollPhysics(),
                      itemCount: controller.items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.updateIndex(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.all(5),
                                width: 90,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: controller.buttonindex == index
                                      ? Colors.white70
                                      : Colors.white54,
                                  borderRadius: controller.buttonindex == index
                                      ? BorderRadius.circular(12)
                                      : BorderRadius.circular(7),
                                  border: controller.buttonindex == index
                                      ? Border.all(
                                      color: Colors.deepPurpleAccent,
                                      width: 2.5)
                                      : null,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        controller.icons[index], // Use index instead of controller.buttonindex
                                        fit: BoxFit.contain, // Adjust the fit as needed
                                        width: 40, // Set a fixed width for consistency
                                        height: 30, // Set a fixed height for consistency
                                      ),
                                      Text(
                                        controller.items[index],
                                        style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.w500,
                                          color: controller.buttonindex == index
                                              ? Colors.black
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.buttonindex == index,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                   controller.check[controller.buttonindex],
              
                ],
              ),
            );
          },
        )
      ),
    );
  }
}
