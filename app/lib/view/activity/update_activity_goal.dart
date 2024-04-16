import 'package:flutter/material.dart';
import 'package:loginsignup/controller/activity/activity_goal_apis.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';
import '../../common_widget/base_widget/textfield.dart';
import '../../controller/auth/auth_apis.dart';

class UpdateActivityGoal extends StatefulWidget {
  final Map<String, dynamic> activityData;

  UpdateActivityGoal({required this.activityData});

  @override
  _UpdateActivityGoal createState() => _UpdateActivityGoal();
}

class _UpdateActivityGoal extends State<UpdateActivityGoal> {
  late TextEditingController _calorieController;
  late TextEditingController _stepController;
  late TextEditingController _runningDistanceController;
  late TextEditingController _flightClimbedController;
  final ApiService apiService = ApiService();

  void _showSnackBarOnPreviousScreen(BuildContext context, String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.secondaryColor2,
        elevation: 0,
        margin: EdgeInsets.only(top: 0,),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calorieController = TextEditingController(
        text: widget.activityData['targetCaloriesBurn']?.toString() ?? '');
    _stepController = TextEditingController(
        text: widget.activityData['targetSteps']?.toString() ?? '');
    _runningDistanceController = TextEditingController(
        text: widget.activityData['targetRunningDistance']?.toString() ?? '');
    _flightClimbedController = TextEditingController(
        text: widget.activityData['targetFlightsClimbed']?.toString() ?? '');
  }

  @override
  void dispose() {
    _calorieController.dispose();
    _stepController.dispose();
    _runningDistanceController.dispose();
    _flightClimbedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              centerTitle: true,
              title: Text(
                "Update Activity Goal",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target Calories Burn',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _calorieController,
                                keywordtype: TextInputType.number,
                                hitText: "Calories Burn",
                                icon: "assets/img/home/burn.png",
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColor.secondaryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Kcal",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Text(
                          'Target Steps',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _stepController,
                                keywordtype: TextInputType.number,
                                hitText: "Steps",
                                icon: "assets/img/home/burn.png",
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColor.secondaryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Steps",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Text(
                          'Target Running Distance',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _runningDistanceController,
                                keywordtype: TextInputType.number,
                                hitText: "Running Distance",
                                icon: "assets/img/home/burn.png",
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColor.secondaryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Km",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Text(
                          'Target Flights Climbed',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _flightClimbedController,
                                keywordtype: TextInputType.number,
                                hitText: "Flights Climbed",
                                icon: "assets/img/home/burn.png",
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColor.secondaryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Floors",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.07,
                        ),
                        RoundButton(
                            title: "Save",
                            onPressed: () async {
                              final body = {
                                'target_calories_burn':
                                    int.parse(_calorieController.text),
                                'target_steps': int.parse(_stepController.text),
                                'target_running_distance': double.parse(
                                    _runningDistanceController.text),
                                'target_flights_climbed':
                                    int.parse(_flightClimbedController.text),
                              };
                              bool isSuccess = await updateUserActivityGoal(
                                  widget.activityData["id"], body);

                              if (isSuccess) {
                                _showSnackBarOnPreviousScreen(
                                    context, 'Activity Goal updated successfully');
                              } else {
                                _showSnackBarOnPreviousScreen(
                                    context, 'Failed to update the goal');
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
