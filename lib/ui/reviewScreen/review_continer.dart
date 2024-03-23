import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';

class ReviewContainer extends StatelessWidget {
  const ReviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Container(
        height: 18.h,
        width: 100.w,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurStyle: BlurStyle.outer,
              )
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            1.h.addHSpace(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Row(
                 children: [
                   CircleAvatar(
                     radius: 30,
                   ),
                   2.w.addWSpace(),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Parth Vyas",
                         style: TextStyle(fontSize: 20),
                       ),
                       Text("27 Aug 2017")
                     ],
                   ),
                 ],
               ),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Icon(Icons.star_rate),
                  ],
                ),
              ],
            ),
            1.h.addHSpace(),
            Text("Home cleaning services offer comprehensive cleaning solutions tailored to meet the needs of residential spaces. These services typically include dusting, vacuuming, mopping floors, cleaning bathrooms and kitchens, and tidying up living areas. Professional cleaners utilize eco-friendly products and advanced equipment to ensure a thorough and hygienic cleaning process." ,maxLines: 3,style: TextStyle(overflow: TextOverflow.ellipsis),)
          ],
        ),
      ),
    );
  }
}
