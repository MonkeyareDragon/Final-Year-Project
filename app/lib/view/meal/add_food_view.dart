import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common/date_function.dart';
import 'package:loginsignup/common_widget/icon_title_row.dart';
import 'package:loginsignup/common_widget/primary_button.dart';

class AddFoodView extends StatefulWidget {
  final DateTime date;
  final Map mObj;
  final Map dObj;
  const AddFoodView({super.key, required this.date, required this.mObj, required this.dObj});

  @override
  State<AddFoodView> createState() => _AddMealViewState();
}

class _AddMealViewState extends State<AddFoodView> {
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
                Text(
                  dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
                  style: TextStyle(color: AppColor.gray, fontSize: 14),
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
                onDateTimeChanged: (newDate) {},
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
          RoundButton(title: "Save", onPressed: () {}),
          const SizedBox(
            height: 20,
          ),
          ],
        ),
      ),
    );
  }
}
