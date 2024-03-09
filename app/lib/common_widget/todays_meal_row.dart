import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginsignup/common/color_extension.dart';

class TodayMealRow extends StatelessWidget {
  final String mealName;
  final Map<String, dynamic> detail;
  const TodayMealRow({super.key, required this.mealName, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                detail["image"].toString(),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
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
                    detail["name"].toString(),
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse('${detail["date"].toString().replaceAll('/', '-')} ${detail["time"]}'))}",
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
                detail["notify_status"]
                    ? "assets/img/home/notification_on.png"
                    : "assets/img/home/notification_off.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}
