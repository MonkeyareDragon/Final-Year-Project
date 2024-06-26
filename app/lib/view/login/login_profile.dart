import 'package:flutter/material.dart';
import 'package:loginsignup/view/login/profile_goal.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';
import '../../common_widget/base_widget/textfield.dart';

class LoginProfileView extends StatefulWidget {
  final int userId;
  const LoginProfileView({super.key, required this.userId});

  @override
  State<LoginProfileView> createState() => _LoginProfileViewState();
}

class _LoginProfileViewState extends State<LoginProfileView> {
  final dobController = TextEditingController();
  final weightNameController = TextEditingController();
  final heightController = TextEditingController();
  String? selectedGender;

  bool validateFields() {
    if (selectedGender == null ||
        dobController.text.isEmpty ||
        weightNameController.text.isEmpty ||
        heightController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/profile/Profile.png",
                  width: media.width / 1.55,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: AppColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.asset(
                                  "assets/img/profile/Gender.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: AppColor.gray,
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: ["Male", "Female"]
                                      .map((name) => DropdownMenuItem<String>(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: AppColor.gray,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: AppColor.gray, fontSize: 12),
                                  ),
                                  value: selectedGender,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        controller: dobController,
                        keywordtype: TextInputType.datetime,
                        hitText: "Date of Birth",
                        icon: "assets/img/profile/Date.png",
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: weightNameController,
                              keywordtype: TextInputType.number,
                              hitText: "Your Weight",
                              icon: "assets/img/profile/Weight.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: heightController,
                              keywordtype: TextInputType.number,
                              hitText: "Your Height",
                              icon: "assets/img/profile/Height.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                        title: "Next >",
                        onPressed: () {
                          if (validateFields()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileGoalView(
                                  userId: widget.userId,
                                  gender: selectedGender!,
                                  dob: dobController.text,
                                  weight: weightNameController.text,
                                  height: heightController.text,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill all the fields.'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
