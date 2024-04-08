import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/nutrition_row.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/controller/activity/activity_goal_apis.dart';
import 'package:loginsignup/controller/activity/activity_prediction_api.dart';
import 'package:loginsignup/model/activity/activity_goal.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class ActivityPredictionView extends StatefulWidget {
  @override
  State<ActivityPredictionView> createState() => _ActivityPredictionView();
}

class _ActivityPredictionView extends State<ActivityPredictionView> {
  List<Map<String, dynamic>> nutritionArr = [];

  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;

  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  int? accelerometerLastInterval;
  int? gyroscopeLastInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.normalInterval;

  List<List<double>> batchData = [];
  bool isActivityStarted = false;
  String? predictedClass;

  //Testing
  final Stopwatch sensorStopwatch = Stopwatch(); // Stopwatch for sensor data collection
  final Stopwatch apiStopwatch = Stopwatch(); // Stopwatch for API response

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: isActivityStarted ? AppColor.secondaryG : AppColor.primaryG,
      )),
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
                      child: Center(
                        child: Text(
                          predictedClass ?? 'No prediction yet.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: RoundButton(
                                  title: isActivityStarted
                                      ? "Stop Activity"
                                      : "Start Activity",
                                  type: isActivityStarted
                                      ? RoundButtonType.bgSGradient
                                      : RoundButtonType.bgGradient,
                                  onPressed: () {
                                    handleButtonPress();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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

  @override
  void initState() {
    super.initState();
    fetchActivityData();

    sensorInterval = SensorInterval.uiInterval;

    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }

  // Method to fetch activity data from API
  void fetchActivityData() async {
    int userId = 4;
    try {
      ActivityGoal activityGoals = await fetchUserActiviytGoal(userId);

      setState(() {
        nutritionArr = [
          {
            "title": "Calories",
            "image": "assets/img/home/burn.png",
            "unit_name": "kCal",
            "value": "${activityGoals.caloriesBurn}",
            "max_value": "${activityGoals.targetCaloriesBurn}",
          },
          {
            "title": "Steps",
            "image": "assets/img/home/burn.png",
            "unit_name": "Steps",
            "value": "${activityGoals.steps}",
            "max_value": "${activityGoals.targetSteps}",
          },
          {
            "title": "Running Distance",
            "image": "assets/img/home/burn.png",
            "unit_name": "Km",
            "value": "${activityGoals.runningDistance}",
            "max_value": "${activityGoals.targetRunningDistance}",
          },
          {
            "title": "Flights Climbed",
            "image": "assets/img/home/burn.png",
            "unit_name": "Floors",
            "value": "${activityGoals.flightsClimbed}",
            "max_value": "${activityGoals.targetFlightsClimbed}",
          },
        ];
      });
    } catch (e) {
      print('Error fetching activity data: $e');
    }
  }

  // Function to handle stopping the activity
  void stopActivity() {
    if (isActivityStarted) {
      sendBatchData(); 
      batchData.clear(); 
      setState(() {
        isActivityStarted = false;
      });
    }
  }

  // Function to send batch data to the API
  Future<void> sendBatchData() async {
    if (batchData.isNotEmpty) {
      String? response = await sendSensorDataToAPI(batchData);
      if (response != null) {
        setState(() {
          predictedClass = response;
        });
      }
    }
  }

  // Function to add sensor data to the batch
  void addSensorDataToBatch() {
    if (_accelerometerEvent != null && _gyroscopeEvent != null) {
      final List<double> accelerometerData = [
        _accelerometerEvent!.x,
        _accelerometerEvent!.y,
        _accelerometerEvent!.z,
      ];
      final List<double> gyroscopeData = [
        _gyroscopeEvent!.x,
        _gyroscopeEvent!.y,
        _gyroscopeEvent!.z,
      ];

      batchData.add([...accelerometerData, ...gyroscopeData]);

      if (batchData.length > 60) {
        batchData.removeAt(0);
      }
    }
  }

  // Function to handle the button press
  Future<void> handleButtonPress() async {
    if (isActivityStarted) {
      stopActivity(); 
    } else {
      setState(() {
        isActivityStarted = true;
      });
      sensorStopwatch.reset(); // Reset sensor stopwatch
      apiStopwatch.reset(); // Reset API stopwatch

      while (isActivityStarted) {
        sensorStopwatch.start(); // Start sensor stopwatch
        addSensorDataToBatch();
        sensorStopwatch.stop(); // Stop sensor stopwatch

        if (batchData.length == 60) {
          
          apiStopwatch.start(); // Start API stopwatch
          await sendBatchData();
          apiStopwatch.stop(); // Stop API stopwatch
          
          print('Sensor data collection time: ${sensorStopwatch.elapsedMilliseconds}ms'); // Print sensor data collection time
          print('API response time: ${apiStopwatch.elapsedMilliseconds}ms'); // Print API response time

          batchData.clear();

        }
        await Future.delayed(Duration(milliseconds: 100)); 
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
