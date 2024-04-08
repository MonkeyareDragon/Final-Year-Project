import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';

class MealRecommendCell extends StatelessWidget {
  final Map fObj;
  final int index;
  const MealRecommendCell({super.key, required this.index, required this.fObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(5),
      width: media.width * 0.5,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEvent
                ? [
                    AppColor.primaryColor2.withOpacity(0.5),
                    AppColor.primaryColor1.withOpacity(0.5)
                  ]
                : [
                    AppColor.secondaryColor2.withOpacity(0.5),
                    AppColor.secondaryColor1.withOpacity(0.5)
                  ],
          ),
          borderRadius:  BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
                fObj["image"].toString(),
                width: media.width * 0.3,
                height: media.width * 0.25,
                fit: BoxFit.contain,
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["name"],
              style: TextStyle(
                  color: AppColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "${fObj["difficulty"]} | ${fObj["time"]} | ${fObj["kcal"]}",
              style: TextStyle(color: AppColor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 35,
              child: RoundButton(
                  fontSize: 12,
                  type: isEvent
                      ? RoundButtonType.bgGradient
                      : RoundButtonType.bgSGradient,
                  title: "View",
                  onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}