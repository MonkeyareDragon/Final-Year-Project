import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';


class PopularMealRow extends StatelessWidget {
  final Map mObj;
  const PopularMealRow({super.key, required this.mObj});

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
            Image.network(
              mObj["food_image"].toString(),
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["food_name"].toString(),
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${mObj["cooking_difficulty"]} | ${mObj["time_required"]} | ${mObj["calories"]}",
                    style: TextStyle(color: AppColor.gray, fontSize: 12),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/img/home/next_icon.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}