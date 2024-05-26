import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/workout/progresswidget.dart';
import 'package:loginsignup/common_widget/workout/timeController.dart';
import 'package:loginsignup/common_widget/workout/timerOption.dart';
import 'package:loginsignup/common_widget/workout/timercard.dart';
import 'package:loginsignup/controller/workout/timer_service.dart';
import 'package:provider/provider.dart';

class StartWorkout extends StatefulWidget {
  final List exerciseSetArr;
  final List customRepeatsList;

  const StartWorkout({Key? key, required this.exerciseSetArr, required this.customRepeatsList})
      : super(key: key);

  @override
  State<StartWorkout> createState() => _StartWorkoutState();
}

class _StartWorkoutState extends State<StartWorkout> {
  @override
  void initState() {
    super.initState();
  }

  List<String> customRepeatsListString = [];

  @override
  Widget build(BuildContext context) {
    customRepeatsListString = widget.customRepeatsList.map((e) => e.toString()).toList();
    final provider = Provider.of<TimeService>(context);
    final seconds = provider.currentDuration % 60;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/home/black_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                TimerCard(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: 170,
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ]),
                      child: Center(
                        child: Text(
                          (provider.currentDuration ~/ 60).toString(),
                          style: TextStyle(
                              fontSize: 70,
                              color: AppColor.primaryColor1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ":",
                      style: TextStyle(
                          fontSize: 50,
                          color: AppColor.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: 170,
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ]),
                      child: Center(
                        child: Text(
                          seconds == 0
                              ? "${seconds.round()}0"
                              : seconds.round().toString(),
                          style: TextStyle(
                              fontSize: 70,
                              color: AppColor.primaryColor1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TimeOptions(workoutTime: customRepeatsListString, slectedTime: double.parse(customRepeatsListString.first)),
                SizedBox(
                  height: 30,
                ),
                TimeController(),
                SizedBox(
                  height: 30,
                ),
                ProgressWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "ROUND",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[350],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "REPEAT",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[350],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
