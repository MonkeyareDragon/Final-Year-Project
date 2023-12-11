import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hey there,",
                style: TextStyle(color: AppColor.gray, fontSize: 16),
              ),
              Text(
                "Create an Account",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              const RoundTextField(
                hitText: "First Name",
                icon: "assets/img/login/Profile.png",
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              const RoundTextField(
                hitText: "Last Name",
                icon: "assets/img/login/Profile.png",
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              const RoundTextField(
                hitText: "Email",
                icon: "assets/img/login/Message.png",
                keywordtype: TextInputType.emailAddress,
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              RoundTextField(
                hitText: "Password",
                icon: "assets/img/login/Lock.png",
                obscureText: true,
                rigtIcon: TextButton(
                    onPressed: () {},
                    child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "assets/img/login/ShowPasswordEye.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColor.gray,
                        ))),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isCheck = !isCheck;
                      });
                    },
                    icon: Icon(
                      isCheck
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_outlined,
                      color: AppColor.gray,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "By continuing you accept our Privacy Policy and\nTerm of Use",
                      style: TextStyle(color: AppColor.gray, fontSize: 10),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: media.width * 0.3,
              ),
              RoundButton(title: "Register", onPressed: () {}),
              SizedBox(
                height: media.width * 0.04,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: AppColor.gray.withOpacity(0.5),
                  )),
                  Text(
                    "  Or  ",
                    style: TextStyle(color: AppColor.black, fontSize: 12),
                  ),
                  Expanded(
                      child: Container(
                    height: 1,
                    color: AppColor.gray.withOpacity(0.5),
                  )),
                ],
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          width: 1,
                          color: AppColor.gray.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "assets/img/login/Google.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * 0.04,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          width: 1,
                          color: AppColor.gray.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "assets/img/login/Facebook.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: media.width * 0.04,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: AppColor.secondaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
