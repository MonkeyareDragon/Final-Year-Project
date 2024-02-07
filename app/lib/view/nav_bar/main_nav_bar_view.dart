import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/nav_button.dart';
import 'package:loginsignup/view/home/blank_view.dart';
import 'package:loginsignup/view/home/home_view.dart';
import 'package:loginsignup/view/nav_bar/select_screen_view.dart';
import 'package:loginsignup/view/profile/profile.dart';

class MainNavBarViewState extends StatefulWidget {
  const MainNavBarViewState({super.key});

  @override
  State<MainNavBarViewState> createState() => MainNavBarViewStateState();
}

class MainNavBarViewStateState extends State<MainNavBarViewState> {
  int selectNav = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget curentNav = HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: PageStorage(bucket: bucket, child: curentNav),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColor.primaryG,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ]),
            child: Image.asset(
              "assets/img/mainscreen/MiddleIcon.png",
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        decoration: BoxDecoration(color: AppColor.white, boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
        ]),
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavButton(
                icon: "assets/img/mainscreen/HomeIcon.png",
                selectIcon: "assets/img/mainscreen/HomeIconSelect.png",
                isActive: selectNav == 0,
                onTap: () {
                  selectNav = 0;
                  curentNav = HomePage();
                  if (mounted) {
                    setState(() {});
                  }
                }),
            NavButton(
                icon: "assets/img/mainscreen/ActivityIcon.png",
                selectIcon: "assets/img/mainscreen/ActivityIconSelect.png",
                isActive: selectNav == 1,
                onTap: () {
                  selectNav = 1;
                  curentNav = const SelectScreenView();
                  if (mounted) {
                    setState(() {});
                  }
                }),
            const SizedBox(
              width: 40,
            ),
            NavButton(
                icon: "assets/img/mainscreen/MealIcon.png",
                selectIcon: "assets/img/mainscreen/MealIconSelect.png",
                isActive: selectNav == 2,
                onTap: () {
                  selectNav = 2;
                  curentNav = BlankView();
                  if (mounted) {
                    setState(() {});
                  }
                }),
            NavButton(
              icon: "assets/img/mainscreen/ProfileIcon.png",
              selectIcon: "assets/img/mainscreen/ProfileIconSelect.png",
              isActive: selectNav == 3,
              onTap: () {
                selectNav = 3;
                curentNav = ProfileView();
                if (mounted) {
                  setState(() {});
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
