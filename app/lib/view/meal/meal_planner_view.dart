import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/common_widget/meal/find_eat_row.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/common_widget/meal/todays_meal_row.dart';
import 'package:loginsignup/controller/meal/meal_apis.dart';
import 'package:loginsignup/controller/meal/meal_graphs_api.dart';
import 'package:loginsignup/controller/meal/meal_notification_apis.dart';
import 'package:loginsignup/model/meal/meal.dart';
import 'package:loginsignup/model/meal/meal_line_graph.dart';
import 'package:loginsignup/model/meal/meal_notification.dart';
import 'package:loginsignup/model/session/user_session.dart';
import 'package:loginsignup/view/meal/find_meal_view.dart';
import 'package:loginsignup/view/meal/meal_schedule_view.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  List findEatArr = [];
  List<Map<String, dynamic>> todayMealArr = [];
  String selectedMealName = "Breakfast";
  List<WeeklyMealProgress> weeklyProgressData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    fetchMealDataList();
    fetchTodayMealSchedule();
    fetchWeeklyProgressData();
  }

  Future<void> fetchWeeklyProgressData() async {
    try {
      final UserSession session = await getSessionOrThrow();
      final response = await fetchWeeklyProgressMealPlan(session.userId);
      setState(() {
        weeklyProgressData = response;
      });
    } catch (e) {
      print('Error fetching weekly progress of meal plan: $e');
    }
  }

  Future<void> fetchTodayMealSchedule() async {
    try {
      final UserSession session = await getSessionOrThrow();
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      final List<TodayMeal> todaymealSchedules = await fetchTodayScheduleMeals(
          session.userId, currentDate, currentTime);

      setState(() {
        todayMealArr.clear();
      });

      for (final todaymealSchedule in todaymealSchedules) {
        final mealName = todaymealSchedule.mealName;
        final mealDetails = todaymealSchedule.details.map((detail) {
          return {
            "name": detail.name,
            "image": detail.image,
            "date": detail.date,
            "time": detail.time,
            "notify_status": detail.notifyStatus,
          };
        }).toList();

        todayMealArr.add({
          'meal_name': mealName,
          'details': mealDetails,
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchMealDataList() async {
    try {
      List<Meal> meals = await fetchMealDetails();
      setState(() {
        findEatArr = meals
            .map((meals) => {
                  "meal_id": meals.id,
                  "meal_name": meals.name,
                  "meal_image": meals.mealImage,
                  "meal_count": meals.foodCount,
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
              "assets/img/home/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Meal Planner",
          style: TextStyle(
              color: AppColor.black, fontSize: 16, fontWeight: FontWeight.w700),
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
      body: RefreshIndicator(
        onRefresh: _refreshUserProfile,
        color: AppColor.white,
        backgroundColor: AppColor.primaryColor1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Meal Nutritions",
                          style: TextStyle(
                              color: AppColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: AppColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: ["Weekly", "Monthly"]
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: AppColor.gray, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {},
                              icon:
                                  Icon(Icons.expand_more, color: AppColor.white),
                              hint: Text(
                                "Weekly",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: media.width * 0.5,
                      width: double.maxFinite,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {},
                            mouseCursorResolver: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response == null ||
                                  response.lineBarSpots == null) {
                                return SystemMouseCursors.basic;
                              }
                              return SystemMouseCursors.click;
                            },
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.transparent,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 3,
                                      strokeColor: AppColor.secondaryColor1,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: AppColor.secondaryColor1,
                              tooltipRoundedRadius: 20,
                              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                                return lineBarsSpot.map((lineBarSpot) {
                                  return LineTooltipItem(
                                    "${lineBarSpot.x.toInt()} mins ago",
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: lineBarsData1,
                          minY: -0.5,
                          maxY: 110,
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(),
                              topTitles: AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: bottomTitles,
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: rightTitles,
                              )),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 25,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: AppColor.gray.withOpacity(0.15),
                                strokeWidth: 2,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daily Meal Schedule",
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 70,
                            height: 25,
                            child: RoundButton(
                              title: "Check",
                              type: RoundButtonType.bgGradient,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MealScheduleView(),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today Meals",
                          style: TextStyle(
                              color: AppColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: AppColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: todayMealArr.map((meal) {
                                return DropdownMenuItem(
                                  value: meal['meal_name'],
                                  child: Text(
                                    meal['meal_name'],
                                    style: TextStyle(
                                        color: AppColor.gray, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMealName = value
                                      .toString(); // Update selected meal name
                                });
                              },
                              icon:
                                  Icon(Icons.expand_more, color: AppColor.white),
                              hint: Text(
                                selectedMealName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todayMealArr.length,
                      itemBuilder: (context, index) {
                        var mObj = todayMealArr[index];
                        var mealName = mObj['meal_name'];
                        var details = mObj['details'];
                        if (mealName == selectedMealName) {
                          return Column(
                            children: details.map<Widget>((detail) {
                              return TodayMealRow(
                                mealName: mealName,
                                detail: detail,
                              );
                            }).toList(),
                          );
                        } else {
                          return SizedBox
                              .shrink(); // Return empty SizedBox for non-matching meals
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Find Something to Eat",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: media.width * 0.55,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: findEatArr.length,
                    itemBuilder: (context, index) {
                      var fObj = findEatArr[index] as Map? ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindMealView(
                                  eObj: fObj,
                                  mealid: fObj["meal_id"],
                                ),
                              ));
                        },
                        child: FindEatRow(
                          fObj: fObj,
                          index: index,
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> get lineBarsData1 {
    List<FlSpot> spots = [];

    for (int i = 0; i < weeklyProgressData.length; i++) {
      spots.add(FlSpot(
          (i + 1).toDouble(), weeklyProgressData[i].progress.toDouble()));
    }

    return [
      LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 1,
            strokeColor: Colors.blue,
          ),
        ),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      ),
    ];
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: AppColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) =>
            bottomTitleWidgets(value, meta, weeklyProgressData),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta,
      List<WeeklyMealProgress> weeklyProgressData) {
    var style = TextStyle(
      color: AppColor.gray,
      fontSize: 12,
    );
    Widget text;
    int index = value.toInt() - 1;

    if (index >= 0 && index < weeklyProgressData.length) {
      var weeklyDay = weeklyProgressData[index].weeklyDay;
      text = Text(weeklyDay, style: style);
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

   Future<void> _refreshUserProfile() async {
    fetchData();
  }
}
