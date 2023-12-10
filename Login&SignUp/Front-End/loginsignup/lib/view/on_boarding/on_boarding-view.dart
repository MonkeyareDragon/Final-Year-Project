import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          PageView.builder(itemBuilder: (context, index) {
            return Container();
          })
        ],
      ),
    );
  }
}
