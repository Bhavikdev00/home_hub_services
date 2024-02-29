import 'package:flutter/material.dart';
import 'package:home_hub_services/constraint/app_color.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
   OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
   double topBarOpacity = 0.0;
   DateTime selectedDate = DateTime.now();
   void _selectedDate(BuildContext context,DateTime date)async{
     final DateTime? picked = await showDatePicker(
         context: context,
         firstDate: DateTime(2015, 8),
         lastDate: DateTime(2101),
     initialDate: selectedDate);
     if (picked != null && picked != selectedDate)
       setState(() {
         selectedDate = picked;
       });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 20,
              floating: true,
              flexibleSpace: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Order List',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 16 + 6 - 6 * topBarOpacity,
                              letterSpacing: 1.2,
                              color: Color(0xFF17262A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        width: 38,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            setState(() {
                              selectedDate = selectedDate.subtract(Duration(days: 1));
                            });
                          },
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Color(0xFF3A5160),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: GestureDetector(
                          onTap: () => _selectedDate(context, selectedDate),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF3A5160),
                                  size: 18,
                                ),
                              ),
                              Text(
                                '${DateFormat('d MMMM').format(selectedDate)}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  letterSpacing: -0.2,
                                  color: Color(0xFF17262A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        width: 38,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            setState(() {
                              selectedDate = selectedDate.add(Duration(days: 1));
                            });
                          },
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xFF3A5160),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
        
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.navigate_next_rounded),
                      ),
                      title: Text("user${index}"),
                      subtitle: Text("DateTime And Paid And Unpaid"),
                      leading: CircleAvatar(
                        radius: 30,
                      ),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
