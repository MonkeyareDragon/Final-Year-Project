import 'package:flutter/material.dart';
import 'package:loginsignup/common_widget/primary_button.dart';
import 'package:loginsignup/view/meal/meal_planner_view.dart';
import 'package:loginsignup/view/workout/workout_tracker_view.dart';

class SelectScreenView extends StatelessWidget {
  const SelectScreenView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
              title: "Workout Tracker",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkOutTrackerView(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            RoundButton(
              title: "Meal Planner",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MealPlannerView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
