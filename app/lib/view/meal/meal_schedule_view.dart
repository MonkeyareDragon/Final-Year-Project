import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/food_schedule_row.dart';
import 'package:loginsignup/common_widget/nutrition_row.dart';
import 'package:loginsignup/controller/meal/meal_notification_apis.dart';
import 'package:loginsignup/model/meal/meal_notification.dart';
import 'package:calendar_agenda/calendar_agenda.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({Key? key}) : super(key: key);

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();

  List<Map<String, dynamic>> nutritionArr = [];
  List<Map<String, dynamic>> mealDetailsList = [];

  @override
  void initState() {
    super.initState();
    fetchMealScheduleData(DateTime.now());
    fetchNutritionData(DateTime.now());
  }

  Future<void> fetchMealScheduleData(DateTime selectedDate) async {
    try {
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate);

      final List<MealSchedule> mealSchedules =
          await fetchMealSchedulerDetailsOnUserID(2, formattedDate);

      setState(() {
        mealDetailsList.clear();
      });

      for (final mealSchedule in mealSchedules) {
        final mealName = mealSchedule.mealName;
        final mealTotalCalories = mealSchedule.totalCalorie;
        final mealDetails = mealSchedule.mealScheduleDetail.map((detail) {
          return {
            "name": detail.name,
            "time": detail.time,
            "image": detail.image,
            "status": detail.status,
            "schedule_id": detail.scheduleId,
            "required_time": detail.requiredTime,
            "notify_status": detail.notifyStatus,
          };
        }).toList();

        mealDetailsList.add({
          'meal_name': mealName,
          'total_calories': mealTotalCalories,
          'details': mealDetails,
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Method to fetch activity data from API
  void fetchNutritionData(DateTime selectedDate) async {
    int userId = 2;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    try {
      DailyMealScheduleNutritions nutritionGoals =
          await fetchDailyMealSchedulerNutritionOnUserID(
              userId, formattedDate); // Pass user id as argument

      // Update nutritionArr with fetched data
      setState(() {
        nutritionArr = [
          {
            "title": "Calories",
            "image": "assets/img/home/burn.png",
            "unit_name": "kCal",
            "value": "${nutritionGoals.totalCalorie}",
            "max_value": "${nutritionGoals.targetCalorie}",
          },
          {
            "title": "Proteins",
            "image": "assets/img/home/proteins.png",
            "unit_name": "g",
            "value": "${nutritionGoals.totalProtein}",
            "max_value": "${nutritionGoals.targetProtein}",
          },
          {
            "title": "Fats",
            "image": "assets/img/home/egg.png",
            "unit_name": "g",
            "value": "${nutritionGoals.totalFat}",
            "max_value": "${nutritionGoals.targetFat}",
          },
          {
            "title": "Carbo",
            "image": "assets/img/home/carbo.png",
            "unit_name": "g",
            "value": "${nutritionGoals.totalCarbohydrate}",
            "max_value": "${nutritionGoals.targetCarbohydrate}",
          },
        ];
      });
    } catch (e) {
      print('Error fetching activity data: $e');
    }
  }

  void _reloadPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              title: Text("Meal Schedule"),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarAgenda(
                controller: _calendarAgendaControllerAppBar,
                appbar: false,
                selectedDayPosition: SelectedDayPosition.center,
                leading: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/img/home/ArrowLeft.png",
                    width: 15,
                    height: 15,
                  ),
                ),
                training: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/img/home/ArrowRight.png",
                    width: 15,
                    height: 15,
                  ),
                ),
                weekDay: WeekDay.short,
                dayNameFontSize: 12,
                dayNumberFontSize: 16,
                dayBGColor: Colors.grey.withOpacity(0.15),
                titleSpaceBetween: 15,
                backgroundColor: Colors.transparent,
                fullCalendarScroll: FullCalendarScroll.horizontal,
                fullCalendarDay: WeekDay.short,
                selectedDateColor: Colors.white,
                dateColor: Colors.black,
                locale: 'en',
                initialDate: DateTime.now(),
                calendarEventColor: AppColor.primaryColor2,
                firstDate: DateTime.now().subtract(const Duration(days: 140)),
                lastDate: DateTime.now().add(const Duration(days: 60)),
                onDateSelected: (date) {
                  fetchMealScheduleData(date);
                  fetchNutritionData(date);
                },
                selectedDayLogo: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColor.primaryG,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: mealDetailsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final mealDetails = mealDetailsList[index];
                  final mealName = mealDetails['meal_name'];
                  final mealTotalCalories = mealDetails['total_calories'];
                  final details = mealDetails['details'];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mealName,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${details.length} Items | $mealTotalCalories calories",
                                style: TextStyle(
                                  color: AppColor.gray,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: details.length,
                        itemBuilder: (context, index) {
                          final detail = details[index];
                          return FoodScheduleRow(
                            mObj: detail,
                            index: index,
                            onReload: _reloadPage,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today Meal Nutritions",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: nutritionArr.length,
                itemBuilder: (context, index) {
                  var nObj = nutritionArr[index];

                  return NutritionRow(
                    nObj: nObj,
                  );
                },
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
}
