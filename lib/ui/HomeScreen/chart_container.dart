import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/utils/extension.dart';

class ChartContainer extends StatefulWidget {
  const ChartContainer(
      {super.key,
        required this.chartColor,
        required this.title,
        required this.value,
        required this.chartValue});
  final Color chartColor;
  final String title;
  final String value;
  final String chartValue;
  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        height: height * 0.15,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: const Offset(2, 2),
                  blurStyle: BlurStyle.outer),
            ]),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.title.semiBoldReadex(
                    fontColor: Colors.black.withOpacity(0.5), fontSize: 14),
                (height * 0.005).addHSpace(),
                widget.value
                    .semiBoldReadex(fontColor: Colors.black, fontSize: 18)
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 65,
              width: 65,
              child: Stack(
                children: [
                  PieChart(PieChartData(sections: [
                    PieChartSectionData(
                        title: "",
                        radius: 8,
                        value: 20,
                        color: Colors.transparent),
                    PieChartSectionData(
                        title: "",
                        radius: 8,
                        value: 60,
                        color: widget.chartColor)
                  ])),
                  Center(
                    child: widget.chartValue
                        .semiBoldReadex(fontColor: Colors.black, fontSize: 13),
                  )
                ],
              ),
            )
          ],
        ).paddingSymmetric(horizontal: width * 0.014),
      ),
    );
  }
}