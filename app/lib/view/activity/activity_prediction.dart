import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/nutrition_row.dart';
import 'package:loginsignup/controller/activity/activity_goal_apis.dart';
import 'package:loginsignup/model/activity/activity_goal.dart';

class ActivityPredictionView extends StatefulWidget {
  @override
  State<ActivityPredictionView> createState() => _ActivityPredictionView();
}

class _ActivityPredictionView extends State<ActivityPredictionView> {
  List<Map<String, dynamic>> nutritionArr = []; // Update the list to hold Map<String, dynamic>

  @override
  void initState() {
    super.initState();
    fetchActivityData(); // Fetch activity data when the view initializes
  }

  // Method to fetch activity data from API
  void fetchActivityData() async {
    int userId = 2;
    try {
      ActivityGoal activityGoals = await fetchUserActiviytGoal(userId); // Pass user id as argument

      // Update nutritionArr with fetched data
      setState(() {
        nutritionArr = [
          {
            "title": "Calories",
            "image": "assets/img/home/burn.png",
            "unit_name": "kCal",
            "value": "${activityGoals.caloriesBurn}", // Update with actual calories burn value
            "max_value": "${activityGoals.targetCaloriesBurn}", // Update with actual target calories burn value
          },
          {
            "title": "Steps",
            "image": "assets/img/home/burn.png",
            "unit_name": "Steps",
            "value": "${activityGoals.steps}", // Update with actual steps value
            "max_value": "${activityGoals.targetSteps}", // Update with actual target steps value
          },
          {
            "title": "Running Distance",
            "image": "assets/img/home/burn.png",
            "unit_name": "Km",
            "value": "${activityGoals.runningDistance}", // Update with actual running distance value
            "max_value": "${activityGoals.targetRunningDistance}", // Update with actual target running distance value
          },
          {
            "title": "Flights Climbed",
            "image": "assets/img/home/burn.png",
            "unit_name": "Floors",
            "value": "${activityGoals.flightsClimbed}", // Update with actual flights climbed value
            "max_value": "${activityGoals.targetFlightsClimbed}", // Update with actual target flights climbed value
          },
        ];
      });
    } catch (e) {
      print('Error fetching activity data: $e');
      // Handle error fetching data
    }
  }

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
                            var nObj = nutritionArr[index];

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
