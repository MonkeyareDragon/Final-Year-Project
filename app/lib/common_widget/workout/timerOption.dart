import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/controller/workout/timer_service.dart';
import 'package:provider/provider.dart';

class TimeOptions extends StatelessWidget {
  final List workoutTime;
  final double slectedTime;
  const TimeOptions({
    super.key,
    required this.workoutTime,
    required this.slectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeService>(context);

    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 240),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: workoutTime.map((time) {
          return InkWell(
            onTap: ()=>provider.selectTime(double.parse(time)),
            child: Container(
              margin: EdgeInsets.only(left: 10),
              width: 70,
              height: 50,
              decoration: int.parse(time) == provider.selectedTime
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    )
                  : BoxDecoration(
                      border: Border.all(width: 3, color: AppColor.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
              child: Center(
                child: Text(
                  (int.parse(time) ~/ 60).toString(),
                  style: TextStyle(
                      fontSize: 25,
                      color: int.parse(time) == provider.selectedTime
                          ? AppColor.primaryColor1
                          : AppColor.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
