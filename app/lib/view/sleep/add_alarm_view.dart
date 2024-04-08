import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/icon_title_row.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';

class AddAlarmView extends StatefulWidget {
  final DateTime date;
  const AddAlarmView({super.key, required this.date});

  @override
  State<AddAlarmView> createState() => _AddAlarmView();
}

class _AddAlarmView extends State<AddAlarmView> {
  bool positive = false;

  @override
  Widget build(BuildContext context) {

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
          "Add Alarm",
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 8,
          ),
          IconTitleNextRow(
              icon: "assets/img/home/Bed_Add.png",
              title: "Bedtime",
              time: "09:00 PM",
              color: AppColor.lightGray,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/img/home/HoursTime.png",
              title: "Hours of sleep",
              time: "8hours 30minutes",
              color: AppColor.lightGray,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/img/home/Repeat.png",
              title: "Repeat",
              time: "Mon to Fri",
              color: AppColor.lightGray,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.lightGray,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/home/Vibrate.png",
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Vibrate When Alarm Sound",
                    style: TextStyle(color: AppColor.gray, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Transform.scale(
                    scale: 0.7,
                    child: CustomAnimatedToggleSwitch<bool>(
                      current: positive,
                      values: [false, true],
                      spacing: 0.0,
                      indicatorSize: const Size.square(30.0),
                      animationDuration: const Duration(milliseconds: 200),
                      animationCurve: Curves.linear,
                      onChanged: (b) => setState(() => positive = b),
                      iconBuilder: (context, local, global) {
                        return const SizedBox();
                      },
                      cursors: ToggleCursors(
                          defaultCursor: SystemMouseCursors.click),
                      onTap: (_) => setState(() => positive = !positive),
                      iconsTappable: false,
                      wrapperBuilder: (context, global, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                left: 10.0,
                                right: 10.0,
                                height: 30.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                colors: global.current
                                    ? AppColor.primaryG
                                    : AppColor.secondaryG),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                  ),
                                )),
                            child,
                          ],
                        );
                      },
                      foregroundIndicatorBuilder: (context, global) {
                        return SizedBox.fromSize(
                          size: const Size(10, 10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black38,
                                    spreadRadius: 0.05,
                                    blurRadius: 1.1,
                                    offset: Offset(0.0, 0.8))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          RoundButton(title: "Add", onPressed: () {}),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
