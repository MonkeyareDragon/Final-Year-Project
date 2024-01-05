import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/view/on_boarding/get_start_view.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'FitnestX',
      debugShowCheckedModeBanner: false,
      // Application theme data, you can set the
      // colors for the application as
      // you want
      theme: ThemeData(
          primaryColor: AppColor.primaryColor1, fontFamily: "Poppins"),

      // A widget which will be started on application startup
      home: AnimatedSplashScreen(
        splash: 'assets/img/splashscreen/SplashScreenImage.png',
        nextScreen: GetStartedView(),
        splashIconSize: 250,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}
