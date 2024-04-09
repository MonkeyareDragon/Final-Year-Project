import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/controller/auth/profile_api.dart';
import 'package:loginsignup/view/login/welcome_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';

class ProfileGoalView extends StatefulWidget {
  final int userId;
  final String gender;
  final String dob;
  final String weight;
  final String height;
  const ProfileGoalView({
    super.key,
    required this.userId,
    required this.gender,
    required this.dob,
    required this.weight,
    required this.height,
  });

  @override
  State<ProfileGoalView> createState() => _ProfileGoalViewState();
}

class _ProfileGoalViewState extends State<ProfileGoalView> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPage = 0;
  String selectedGoal = 'Improve Shape';

  List goalArray = [
    {
      "image": "assets/img/profile/GoalImage1.png",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat\nand need / want to build more\nmuscle"
    },
    {
      "image": "assets/img/profile/GoalImage2.png",
      "title": "Lean & Tone",
      "subtitle":
          "I’m “skinny fat”. look thin but have\nno shape. I want to add learn\nmuscle in the right way"
    },
    {
      "image": "assets/img/profile/GoalImage3.png",
      "title": "Lose a Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass"
    },
  ];

  void _confirmProfile() async {
    try {
      print(widget.userId);
      print(widget.gender);
      print(widget.dob);
      print(widget.weight);
      print(widget.height);
      print(selectedGoal);
      Map<String, dynamic> result = await setUserProfile(
        userId: widget.userId,
        gender: widget.gender,
        dob: widget.dob,
        weight: widget.weight,
        height: widget.height,
        goal: selectedGoal,
      );

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeView(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error setting profile: ${result['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: CarouselSlider(
              items: goalArray
                  .map(
                    (gObj) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: AppColor.primaryG,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: media.width * 0.1, horizontal: 25),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Image.asset(
                              gObj["image"].toString(),
                              width: media.width * 0.5,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            Text(
                              gObj["title"].toString(),
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              width: media.width * 0.1,
                              height: 1,
                              color: AppColor.white,
                            ),
                            SizedBox(
                              height: media.width * 0.02,
                            ),
                            Text(
                              gObj["subtitle"].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.7,
                aspectRatio: 0.88,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPage = index;
                    selectedGoal = goalArray[currentPage]['title'];
                  });
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: media.width,
            child: Column(
              children: [
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "What is your goal ?",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to choose a best\nprogram for you",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.gray, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: RoundButton(
                            title: "Confirm",
                            onPressed: _confirmProfile,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
