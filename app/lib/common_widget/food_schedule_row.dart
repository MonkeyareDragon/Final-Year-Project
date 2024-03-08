import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:intl/intl.dart';
import 'package:loginsignup/common_widget/icon_title_row.dart';
import 'package:loginsignup/common_widget/primary_button.dart';
import 'package:loginsignup/controller/meal/meal_notification_apis.dart';

class FoodScheduleRow extends StatelessWidget {
  final Map mObj;
  final int index;
  final Function onReload;
  const FoodScheduleRow({Key? key, required this.mObj, required this.index, required this.onReload}): super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime time = DateFormat('HH:mm:ss').parse(mObj["time"]);
    String formattedTime = DateFormat('h:mm a').format(time);
    Color chipColor = mObj["status"] == "Completed"
        ? AppColor.primaryColor2
        : AppColor.secondaryColor2;
    var media = MediaQuery.of(context).size;

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
                    color: index % 2 == 0
                        ? AppColor.primaryColor2.withOpacity(0.4)
                        : AppColor.secondaryColor2.withOpacity(0.4),
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
            Chip(
              label: Text(
                mObj["status"].toString(),
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 10, // Decreased font size to 8
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: chipColor.withOpacity(0.8),
              padding: EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4), // Adjusted padding
            ),
            const SizedBox(
              width: 25,
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: media.height * 0.5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
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
                              Text(
                                "Meal Schedule",
                                style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
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
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Food Details",
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconTitleNextRow(
                              icon: "assets/img/home/Icon-Barbel.png",
                              title: "Chosen Food",
                              time: "${mObj["name"].toString()}",
                              color: AppColor.lightGray,
                              onPressed: () {}),
                          const SizedBox(
                            height: 10,
                          ),
                          IconTitleNextRow(
                              icon: "assets/img/home/repetitions.png",
                              title: "Preparation Time",
                              time: "${mObj["required_time"].toString()} mins",
                              color: AppColor.lightGray,
                              onPressed: () {}),
                          const SizedBox(
                            height: 15,
                          ),
                          if (mObj["notify_status"] == false)
                            Center(
                              child: Text(
                                "This is display to note that the given food is not available at this time.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.secondaryColor1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Row(
                            children: [
                              if (mObj["notify_status"] == true)
                                Expanded(
                                  child: RoundButton(
                                      title: "Mark Done",
                                      onPressed: () async {
                                        patchMealSchedulerStatus(
                                            mObj["schedule_id"]);
                                        Navigator.pop(context);
                                        onReload();
                                      }),
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RoundButton(
                                  title: "Delete",
                                  onPressed: () async {
                                    deleteMealScheduler(mObj["schedule_id"]);
                                    Navigator.pop(context);
                                    onReload();
                                  },
                                  type: RoundButtonType.bgSGradient,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
                onReload();
              },
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
