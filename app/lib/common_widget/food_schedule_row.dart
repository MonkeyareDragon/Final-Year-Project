import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:intl/intl.dart';

class FoodScheduleRow extends StatelessWidget {
  final Map mObj;
  final int index;
  const FoodScheduleRow({super.key, required this.mObj, required this.index});

  @override
  Widget build(BuildContext context) {
    DateTime time = DateFormat('HH:mm:ss').parse(mObj["time"]);
    String formattedTime = DateFormat('h:mm a').format(time);
    
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    color: index % 2 == 0 ? AppColor.primaryColor2.withOpacity(0.4) : AppColor.secondaryColor2.withOpacity(0.4) ,
                    borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                child: Image.network(
                  mObj["image"].toString(),
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["name"].toString(),
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: AppColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/img/home/next_go.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}