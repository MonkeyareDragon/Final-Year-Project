import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/nutrition_row.dart';
import 'package:loginsignup/common_widget/primary_button.dart';

class ActivityPredictionView extends StatefulWidget {
  @override
  State<ActivityPredictionView> createState() => _ActivityPredictionView();
}

class _ActivityPredictionView extends State<ActivityPredictionView> {
  List nutritionArr = [
    {
      "title": "Calories",
      "image": "assets/img/home/burn.png",
      "unit_name": "kCal",
      "value": "350",
      "max_value": "500",
    },
    {
      "title": "Steps",
      "image": "assets/img/home/burn.png",
      "unit_name": "Steps",
      "value": "300",
      "max_value": "1000",
    },
    {
      "title": "Running Distance",
      "image": "assets/img/home/burn.png",
      "unit_name": "Km",
      "value": "140",
      "max_value": "1000",
    },
    {
      "title": "Flights Climbed",
      "image": "assets/img/home/burn.png",
      "unit_name": "Floors",
      "value": "140",
      "max_value": "1000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: AppColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leadingWidth: 0,
                leading: Container(),
                expandedHeight: media.width * 0.8,
                flexibleSpace: ClipRect(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                  Transform.scale(
                    scale: 1.25,
                    child: Container(
                      width: media.width * 0.57,
                      height: media.width * 0.57,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(media.width * 0.275),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.25,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ])))
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppColor.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today Task",
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: nutritionArr.length,
                          itemBuilder: (context, index) {
                            var nObj = nutritionArr[index] as Map? ?? {};

                            return NutritionRow(
                              nObj: nObj,
                            );
                          }),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
