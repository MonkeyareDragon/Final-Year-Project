import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/primary_button.dart';
import 'package:loginsignup/view/login/login_view.dart';
import 'package:loginsignup/view/login/password_recovery.dart';

class LinkSendConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: media.width * 0.27,
              ),
              Text(
                "Check your Email",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 15),
              Text(
                "Please got to you <account> email and click the password reset link we’ve sent for your <username> FitnestX account.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "It could take a few minutes to appear and be sure to check any spam and promotional folders-just in case!",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 25),
              RoundButton(
                  title: "Done",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
                  }),
              RoundButton(
                  title: "Start over",
                  isBlack: true,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordRecoveryScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
