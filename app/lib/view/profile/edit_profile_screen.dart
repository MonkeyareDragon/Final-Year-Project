import 'package:flutter/material.dart';
import 'package:loginsignup/controller/profile/profile_api.dart';
import '../../common/color_extension.dart';
import '../../common_widget/base_widget/primary_button.dart';
import '../../common_widget/base_widget/textfield.dart';
import '../../controller/auth/auth_apis.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  EditProfilePage({required this.profileData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  final ApiService apiService = ApiService();

  String? selectedGender;
  String? selectedGoalType;

  void _showSnackBarOnPreviousScreen(BuildContext context, String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.secondaryColor2,
        elevation: 0,
        margin: EdgeInsets.only(top: 0,),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.profileData['username']);
    _firstNameController =
        TextEditingController(text: widget.profileData['first_name']);
    _lastNameController =
        TextEditingController(text: widget.profileData['last_name']);
    selectedGender = widget.profileData['gender'];
    _dobController = TextEditingController(text: widget.profileData['dob']);
    _weightController =
        TextEditingController(text: widget.profileData['weight'].toString());
    _heightController =
        TextEditingController(text: widget.profileData['height'].toString());
    selectedGoalType = widget.profileData['goal'];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              centerTitle: true,
              title: Text(
                "Edit Profile",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppColor.lightGray, width: 4.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(125),
                            child: Image.asset(
                              "assets/img/profile/Profile.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColor.black),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _usernameController,
                                keywordtype: TextInputType.text,
                                hitText: "User Name",
                                icon: "assets/img/profile/UserProfile.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _firstNameController,
                                keywordtype: TextInputType.text,
                                hitText: "First Name",
                                icon: "assets/img/profile/SurnameUser.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RoundTextField(
                                controller: _lastNameController,
                                keywordtype: TextInputType.text,
                                hitText: "Last Name",
                                icon: "assets/img/profile/SurnameUser.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
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
                                      "Choose Goal",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Image.asset(
                                    "assets/img/profile/GoalIcon.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: AppColor.gray,
                                  )),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    items: [
                                      "Gain Weight",
                                      "Maintain Weight",
                                      "Lose Weight"
                                    ]
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
                                        selectedGoalType = value;
                                      });
                                    },
                                    isExpanded: true,
                                    hint: Text(
                                      "Choose Goal",
                                      style: TextStyle(
                                          color: AppColor.gray, fontSize: 12),
                                    ),
                                    value: selectedGoalType,
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
                          controller: _dobController,
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
                                controller: _weightController,
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
                                controller: _heightController,
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
                            title: "Save",
                            onPressed: () async {
                              final body = {
                                'gender': selectedGender,
                                'dob': _dobController.text,
                                'weight': double.parse(_weightController.text),
                                'height': double.parse(_heightController.text),
                                'goal': selectedGoalType,
                                'user': {
                                  'username': _usernameController.text,
                                  'first_name': _firstNameController.text,
                                  'last_name': _lastNameController.text,
                                },
                              };
                              bool isSuccess = await updateUserProfile(body);

                              if (isSuccess) {
                                _showSnackBarOnPreviousScreen(
                                    context, 'Profile updated successfully');
                              } else {
                                _showSnackBarOnPreviousScreen(
                                    context, 'Failed to update the profile');
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
