import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/view/sleep/add_alarm_view.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../common_widget/today_sleep_schedule_row.dart';

class SleepScheduleView extends StatefulWidget {
  const SleepScheduleView({super.key});

  @override
  State<SleepScheduleView> createState() => _SleepScheduleViewState();
}

class _SleepScheduleViewState extends State<SleepScheduleView> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateAppBBar;

  List todaySleepArr = [
    {
      "name": "Bedtime",
      "image": "assets/img/home/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes"
    },
    {
      "name": "Alarm",
      "image": "assets/img/home/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes"
    },
  ];

  List<int> showingTooltipOnSpots = [4];

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
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
          "Sleep Schedule",
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
          )
        ],
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    height: media.width * 0.4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColor.primaryColor2.withOpacity(0.4),
                          AppColor.primaryColor1.withOpacity(0.4)
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Ideal Hours for Sleep",
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "8hours 30minutes",
                                style: TextStyle(
                                    color: AppColor.primaryColor2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 110,
                                height: 35,
                                child: RoundButton(
                                    title: "Learn More",
                                    fontSize: 12,
                                    onPressed: () {}),
                              )
                            ]),
                        Image.asset(
                          "assets/img/home/sleep_schedule.png",
                          width: media.width * 0.35,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Your Schedule",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
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
                      )),
                  training: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/img/home/ArrowRight.png",
                        width: 15,
                        height: 15,
                      )),
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
                    _selectedDateAppBBar = date;
                  },
                  selectedDayLogo: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: AppColor.primaryG,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.03,
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: todaySleepArr.length,
                    itemBuilder: (context, index) {
                      var sObj = todaySleepArr[index] as Map? ?? {};
                      return TodaySleepScheduleRow(
                        sObj: sObj,
                      );
                    }),
                Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColor.secondaryColor2.withOpacity(0.4),
                          AppColor.secondaryColor1.withOpacity(0.4)
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You will get 8hours 10minutes\nfor tonight",
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SimpleAnimationProgressBar(
                              height: 15,
                              width: media.width - 80,
                              backgroundColor: Colors.grey.shade100,
                              foregrondColor: Colors.purple,
                              ratio: 0.96,
                              direction: Axis.horizontal,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(7.5),
                              gradientColor: LinearGradient(
                                  colors: AppColor.secondaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                            ),
                            Text(
                              "96%",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlarmView(
                date: _selectedDateAppBBar,
              ),
            ),
          );
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColor.secondaryG),
              borderRadius: BorderRadius.circular(27.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 20,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}