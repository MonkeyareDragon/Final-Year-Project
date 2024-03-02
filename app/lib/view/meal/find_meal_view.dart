import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/meal_category_cell.dart';
import 'package:loginsignup/common_widget/meal_recommendation_cell.dart';
import 'package:loginsignup/common_widget/popular_meal_row.dart';
import 'package:loginsignup/controller/meal/meal_apis.dart';
import 'package:loginsignup/model/meal/category.dart';
import 'package:loginsignup/model/meal/food.dart';
import 'package:loginsignup/view/meal/food_details_view.dart';

class FindMealView extends StatefulWidget {
  final Map eObj;
  final int mealid;
  const FindMealView({super.key, required this.eObj, required this.mealid});

  @override
  State<FindMealView> createState() => _FindMealView();
}

class _FindMealView extends State<FindMealView> {
  TextEditingController txtSearch = TextEditingController();

  List categoryArr = [];

  List popularArr = [];

  List recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/home/rd_1.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal"
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/home/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal"
    },
  ];

  @override
  void initState() {
    super.initState();
    categoryListDisplay();
    foodListDisplay();
  }

  Future<void> categoryListDisplay() async {
    try {
      List<Category> categories =
          await fetchCategoryDetailsOnMealID(widget.mealid);
      setState(() {
        categoryArr = categories
            .map((categories) => {
                  "name": categories.name,
                  "image": categories.categoryImage,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }


  Future<void> foodListDisplay() async {
    try {
      List<Food> foods =
          await fetchFoodDetailsOnMealID(widget.mealid);
      setState(() {
        popularArr = foods
            .map((foods) => {
                  "food_id": foods.id,
                  "food_image": foods.foodImage,
                  "food_name": foods.name,
                  "cooking_difficulty": foods.cookingDifficulty,
                  "time_required": foods.timeRequired,
                  "calories": foods.calories,
                  "author": foods.author,
                  "description": foods.description
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/home/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["meal_name"].toString(),
          style: TextStyle(
              color: AppColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/img/home/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtSearch,
                      decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          prefixIcon: Image.asset(
                            "assets/img/home/search.png",
                            width: 25,
                            height: 25,
                          ),
                          hintText: "Search Pancake"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 1,
                    height: 25,
                    color: AppColor.gray.withOpacity(0.3),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/img/home/Filter.png",
                      width: 25,
                      height: 25,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.02,
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: categoryArr.length,
                itemBuilder: (context, index) {
                  var cObj = categoryArr[index] as Map? ?? {};
                  return MealCategoryCell(
                    cObj: cObj,
                    index: index,
                  );
                },
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recommendation base on\nyour Diet",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.02,
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: recommendArr.length,
                itemBuilder: (context, index) {
                  var fObj = recommendArr[index] as Map? ?? {};
                  return MealRecommendCell(
                    fObj: fObj,
                    index: index,
                  );
                },
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Popular",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: popularArr.length,
                itemBuilder: (context, index) {
                  var fObj = popularArr[index] as Map? ?? {};
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailsView(
                            dObj: fObj,
                            mObj: widget.eObj,
                            foodid: fObj["food_id"],
                          ),
                        ),
                      );
                    },
                    child: PopularMealRow(
                      mObj: fObj,
                    ),
                  );
                }),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
