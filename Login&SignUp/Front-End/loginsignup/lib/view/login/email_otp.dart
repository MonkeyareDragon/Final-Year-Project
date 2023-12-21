import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/textfield.dart';

class EmailOtpPage extends StatefulWidget {
  @override
  _EmailOtpPageState createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  String otp = '';

  void _submitOTP() {
    // TODO: Implement OTP verification logic
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: media.width * 0.27,
              ),
              Text(
                "Enter Code",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 15),
              Text(
                "We’ve sent a mail with an activation code\n to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 35),
              RoundTextField(
                  hitText: "Activation Code",
                  icon: "assets/img/signup/Message.png",
                  keywordtype: TextInputType.numberWithOptions(),
                  rigtIcon: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                      ),
                    ),
                  )),
              SizedBox(height: 35),
              RoundButton(title: "Login", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
