import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/base_widget/primary_button.dart';
import 'package:loginsignup/view/login/login_view.dart';
import 'package:loginsignup/view/login/password_recovery.dart';

class LinkSendConfirmPage extends StatefulWidget {
  final String linkSendEmail;

  const LinkSendConfirmPage({Key? key, required this.linkSendEmail})
      : super(key: key);

  @override
  State<LinkSendConfirmPage> createState() => _LinkSendConfirmPage();
}

class _LinkSendConfirmPage extends State<LinkSendConfirmPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Please go to your ",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: widget.linkSendEmail,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            " email and click the password reset link we’ve sent for your <username> FitnestX account.",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
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
                SizedBox(height: 15),
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
      ),
    );
  }
}
