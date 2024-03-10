import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/primary_button.dart';
import 'package:loginsignup/common_widget/stpes_details_row.dart';
import 'package:loginsignup/controller/workout/workout_api.dart';
import 'package:loginsignup/model/workout/exercise.dart';
import 'package:readmore/readmore.dart';

class WorkoutStepDescription extends StatefulWidget {
  final Map eObj;
  final int exerciseId;
  const WorkoutStepDescription({super.key, required this.eObj, required this.exerciseId});

  @override
  State<WorkoutStepDescription> createState() => _WorkoutStepDescription();
}

class _WorkoutStepDescription extends State<WorkoutStepDescription> {
  List stepArr = [];

  @override
  void initState() {
    super.initState();
    fetchEquipmentsDataList();
  }

  Future<void> fetchEquipmentsDataList() async {
    try {
      List<ExerciseDescription> exerciseDescList =
          await fetchExerciseDescriptionById(widget.eObj["exercise_id"]);
      setState(() {
        stepArr = exerciseDescList
            .map((exerciseDesc) => {
                  "step_no": exerciseDesc.stepNo,
                  "header": exerciseDesc.header,
                  "description": exerciseDesc.description,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
              "assets/img/home/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/home/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
       backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: AppColor.primaryG),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.network(
                      widget.eObj["exercise_image"].toString(),
                      width: media.width,
                      height: media.width * 0.43,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        color: AppColor.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                   IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/img/home/Play.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
               ),
               const SizedBox(
                height: 15,
              ),
              Text(
                widget.eObj["exercise_name"].toString(),
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "${widget.eObj["exercise_difficulty"].toString()} | ${widget.eObj["exercise_calories_burn"].toString()} Calories Burn",
                style: TextStyle(
                  color: AppColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Descriptions",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              ReadMoreText(
                widget.eObj["exercise_description"].toString(),
                trimLines: 4,
                colorClickableText: AppColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  color: AppColor.gray,
                  fontSize: 12,
                ),
                moreStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${stepArr.length} Sets",
                      style: TextStyle(color: AppColor.gray, fontSize: 12),
                    ),
                  )
                ],
              ),
               ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stepArr.length,
                itemBuilder: ((context, index) {
                  var sObj = stepArr[index] as Map? ?? {};

                  return StepDetailRow(
                    sObj: sObj,
                    isLast: stepArr.last == sObj,
                  );
                }),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Custom Repetitions",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.gray.withOpacity(0.2), width: 1),
                        bottom: BorderSide(
                            color: AppColor.gray.withOpacity(0.2), width: 1),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/home/burn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          " ${(index + 1) * 15} Calories Burn",
                          style: TextStyle(color: AppColor.gray, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                              color: AppColor.gray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " times",
                          style: TextStyle(color: AppColor.gray, fontSize: 16),
                        )
                      ],
                    );
                  },
                ),
              ),
              RoundButton(title: "Save", onPressed: () {}),
              const SizedBox(
                height: 15,
              ),
            ]
          )
        )
      )
    );
  }
}
