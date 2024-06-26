import 'package:flutter/material.dart';
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/model/session/user_session.dart';
import 'package:loginsignup/view/nav_bar/main_nav_bar_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  UserSession? session;

  @override
  void initState() {
    super.initState();
    _fetchSession();
  }

  Future<void> _fetchSession() async {
    try {
      session = await getSessionOrThrow();
      setState(() {});
    } catch (e) {
      print('Error fetching session: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    String firstName = session?.firstName ?? 'Loading..';

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: media.width * 0.1,
              ),
              Image.asset(
                "assets/img/login/Welcome.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Text(
                "Welcome to the Journey, ${firstName}",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
               SizedBox(
                height: media.width * 0.04,
              ),
              Text(
                "You are all set now, let’s reach your\ngoals together with us.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.gray, fontSize: 12),
              ),
              const Spacer(),
              RoundButton(title: "Go To Home", onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainNavBarViewState()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
