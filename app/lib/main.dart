import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/controller/helper/session_manager.dart';
import 'package:loginsignup/model/session/user_session.dart';
import 'package:loginsignup/view/login/login_view.dart';
import 'package:loginsignup/view/nav_bar/main_nav_bar_view.dart';
import 'package:loginsignup/view/on_boarding/get_start_view.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(MyApp());
}

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
        nextScreen: determineNextScreen(),
        splashIconSize: 250,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }

  Widget determineNextScreen() {
    return FutureBuilder<Widget>(
      future: getNextScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> getNextScreen() async {
    final bool isFirstTime = await SessionManager.isFirstTime();

    final UserSession? userSession = await SessionManager.getSession();
    final bool hasSession = userSession != null;

    if (isFirstTime && !hasSession) {
      return GetStartedView();
    } else if (!isFirstTime && !hasSession) {
      return LoginView();
    } else {
      return MainNavBarViewState();
    }
  }
}
