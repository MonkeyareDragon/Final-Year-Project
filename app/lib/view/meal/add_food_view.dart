import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common/date_function.dart';
import 'package:loginsignup/common_widget/icon_title_row.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/controller/meal/meal_notification_apis.dart';
import 'package:intl/intl.dart';

class AddFoodView extends StatefulWidget {
  final DateTime date;
  final Map mObj;
  final Map dObj;
  const AddFoodView(
      {super.key, required this.date, required this.mObj, required this.dObj});

  @override
  State<AddFoodView> createState() => _AddMealViewState();
}

class _AddMealViewState extends State<AddFoodView> {
  late DateTime _selectedDate;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _selectedTime = DateTime.now();
  }

  Future<void> FoodSchedule(Map<String, dynamic> requestData) async {
    await createFoodSchedule(requestData);
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
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
        title: Text(
          "Add to ${widget.mObj["meal_name"]} Meal",
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/img/home/date.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: () {
                    _showDatePicker(context);
                  },
                  child: Text(
                    dateToString(_selectedDate, formatStr: "E, dd MMMM yyyy"),
                    style: TextStyle(color: AppColor.gray, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Time",
              style: TextStyle(
                  color: AppColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                onDateTimeChanged: (newTime) {
                  _selectedTime = newTime;
                },
                initialDateTime: DateTime.now(),
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Food Details",
              style: TextStyle(
                  color: AppColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            IconTitleNextRow(
                icon: "assets/img/home/Icon-Barbel.png",
                title: "Chosen Food",
                time: "${widget.dObj["food_name"]}",
                color: AppColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/home/difficulity.png",
                title: "Difficulity",
                time: "${widget.dObj["cooking_difficulty"]}",
                color: AppColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/home/repetitions.png",
                title: "Prepeartion Time",
                time: "${widget.dObj["time_required"]}mins",
                color: AppColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/home/repetitions.png",
                title: "Calories Obtain",
                time: "${widget.dObj["calories"]}kCal",
                color: AppColor.lightGray,
                onPressed: () {}),
            Spacer(),
            RoundButton(
                title: "Save",
                onPressed: () {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                  
                  String formateTime = DateFormat('hh:mm:ss').format(_selectedTime);

                  Map<String, dynamic> requestData = {
                    'date': formattedDate.toString(),
                    'time': formateTime.toString(),
                    'food': widget.dObj['food_id'],
                    'user': 2
                  };

                  // Call the method with the request data
                  FoodSchedule(requestData);
                }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
