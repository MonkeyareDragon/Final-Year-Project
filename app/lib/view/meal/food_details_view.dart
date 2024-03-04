import 'package:flutter/material.dart';
import 'package:loginsignup/common/color_extension.dart';
import 'package:loginsignup/common_widget/food_making_steps_row.dart';
import 'package:loginsignup/common_widget/primary_button.dart';
import 'package:loginsignup/controller/meal/meal_apis.dart';
import 'package:loginsignup/model/meal/food_make_steps.dart';
import 'package:loginsignup/model/meal/ingredient.dart';
import 'package:loginsignup/model/meal/nutrition.dart';
import 'package:loginsignup/view/meal/add_food_view.dart';
import 'package:readmore/readmore.dart';

class FoodDetailsView extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  final int foodid;
  const FoodDetailsView(
      {super.key,
      required this.dObj,
      required this.mObj,
      required this.foodid});

  @override
  State<FoodDetailsView> createState() => _FoodDetailsView();
}

class _FoodDetailsView extends State<FoodDetailsView> {
  late DateTime _selectedDateAppBBar;
  List nutritionArr = [];
  List ingredientsArr = [];
  List stepArr = [];

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    nutritionListDisplay();
    ingredientListDisplay();
    foodMakingStepsListDisplay();
  }

  Future<void> nutritionListDisplay() async {
    try {
      List<Nutrition> nutritions =
          await fetchNutritionsBaseOnFood(widget.foodid);
      setState(() {
        nutritionArr = nutritions
            .map((nutritions) => {
                  "nutrition_id": nutritions.id,
                  "nutrition_image": nutritions.nutritionImage,
                  "nutrition_name": nutritions.name,
                  "nutrition_quantity": nutritions.quantity,
                  "nutrition_property": nutritions.property,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }

  Future<void> ingredientListDisplay() async {
    try {
      List<Ingredient> ingredients =
          await fetchIngredientBaseOnFood(widget.foodid);
      setState(() {
        ingredientsArr = ingredients
            .map((ingredients) => {
                  "ingredient_id": ingredients.id,
                  "ingredient_image": ingredients.ingredientImage,
                  "name": ingredients.name,
                  "quantity_required": ingredients.quantityRequired,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }

  Future<void> foodMakingStepsListDisplay() async {
    try {
      List<FoodMakingSteps> steps =
          await fetchFoodMakingStepsBaseOnFood(widget.foodid);
      setState(() {
        stepArr = steps
            .map((steps) => {
                  "id": steps.id,
                  "description": steps.description,
                  "step_no": steps.stepNumber,
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
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: AppColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
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
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    "assets/img/home/black_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
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
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/home/more_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leadingWidth: 0,
                leading: Container(),
                expandedHeight: media.width * 0.5,
                flexibleSpace: ClipRect(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                  Transform.scale(
                    scale: 1.25,
                    child: Container(
                      width: media.width * 0.55,
                      height: media.width * 0.55,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(media.width * 0.275),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.25,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.network(
                        widget.dObj["food_image"].toString(),
                        width: media.width * 0.50,
                        height: media.width * 0.50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ])))
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppColor.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dObj["food_name"].toString(),
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "by ${widget.dObj["author"].toString()}",
                                    style: TextStyle(
                                        color: AppColor.gray, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Image.asset(
                                "assets/img/home/fav.png",
                                width: 15,
                                height: 15,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Nutrition",
                          style: TextStyle(
                              color: AppColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: nutritionArr.length,
                          itemBuilder: (context, index) {
                            var nObj = nutritionArr[index] as Map? ?? {};
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.primaryColor2.withOpacity(0.4),
                                      AppColor.primaryColor1.withOpacity(0.4)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    nObj["nutrition_image"].toString(),
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${nObj["nutrition_quantity"].toString()}${nObj["nutrition_property"].toString()} ${nObj["nutrition_name"].toString()}",
                                      style: TextStyle(
                                          color: AppColor.black, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Descriptions",
                          style: TextStyle(
                              color: AppColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ReadMoreText(
                          widget.dObj["description"].toString(),
                          trimLines: 4,
                          colorClickableText: AppColor.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Read More ...',
                          trimExpandedText: ' Read Less',
                          style: TextStyle(
                            color: AppColor.gray,
                            fontSize: 12,
                          ),
                          moreStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ingredients That You\nWill Need",
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${stepArr.length} Items",
                                style: TextStyle(
                                    color: AppColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (media.width * 0.25) + 40,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: ingredientsArr.length,
                          itemBuilder: (context, index) {
                            var nObj = ingredientsArr[index] as Map? ?? {};
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: media.width * 0.23,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: media.width * 0.23,
                                    height: media.width * 0.23,
                                    decoration: BoxDecoration(
                                        color: AppColor.lightGray,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      nObj["ingredient_image"].toString(),
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    nObj["name"].toString(),
                                    style: TextStyle(
                                        color: AppColor.black, fontSize: 12),
                                  ),
                                  Text(
                                    nObj["quantity_required"].toString(),
                                    style: TextStyle(
                                        color: AppColor.gray, fontSize: 10),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Step by Step",
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${stepArr.length} Steps",
                                style: TextStyle(
                                    color: AppColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        itemCount: stepArr.length,
                        itemBuilder: ((context, index) {
                          var sObj = stepArr[index] as Map? ?? {};

                          return FoodMakingStepsRow(
                            sObj: sObj,
                            isLast: stepArr.last == sObj,
                          );
                        }),
                      ),
                      SizedBox(
                        height: media.width * 0.15,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: RoundButton(
                            title: "Add to ${widget.mObj["meal_name"]} Meal",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFoodView(
                                    date: _selectedDateAppBBar,
                                    mObj: widget.mObj,
                                    dObj: widget.dObj,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
