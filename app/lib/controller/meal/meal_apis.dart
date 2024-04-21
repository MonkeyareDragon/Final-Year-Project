import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/meal/category.dart';
import 'package:loginsignup/model/meal/food.dart';
import 'package:loginsignup/model/meal/food_make_steps.dart';
import 'package:loginsignup/model/meal/ingredient.dart';
import 'package:loginsignup/model/meal/meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/model/meal/nutrition.dart';
import 'package:loginsignup/model/session/user_session.dart';

// API call to fetch all the data of meals
Future<List<Meal>> fetchMealDetails() async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/meal-list/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Meal.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  } catch (e) {
    print('Error fetching meals: $e');
    throw Exception('Failed to fetch meals: $e');
  }
}

// API call to fetch all the data of category base on meal id
Future<List<Category>> fetchCategoryDetailsOnMealID(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/categories/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load category');
    }
  } catch (e) {
    print('Error fetching category: $e');
    throw Exception('Failed to fetch category: $e');
  }
}


// API call to fetch all the data of food base on meal id
Future<List<Food>> fetchFoodDetailsOnMealID(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/foods/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Food.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  } catch (e) {
    print('Error fetching foods: $e');
    throw Exception('Failed to fetch foods: $e');
  }
}


// API call to fetch all the data of nutrition base on food id
Future<List<Nutrition>> fetchNutritionsBaseOnFood(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/nutrition/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Nutrition.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Nutritions');
    }
  } catch (e) {
    print('Error fetching Nutritions: $e');
    throw Exception('Failed to fetch Nutritions: $e');
  }
}


// API call to fetch all the data of ingredient base on food id
Future<List<Ingredient>> fetchIngredientBaseOnFood(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/ingredient/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Ingredient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  } catch (e) {
    print('Error fetching ingredients: $e');
    throw Exception('Failed to fetch ingredients: $e');
  }
}


// API call to fetch all the data of Food Making Steps on food id
Future<List<FoodMakingSteps>> fetchFoodMakingStepsBaseOnFood(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/food-making-steps/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => FoodMakingSteps.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load food makingsteps');
    }
  } catch (e) {
    print('Error fetching food making steps: $e');
    throw Exception('Failed to fetch food making steps: $e');
  }
}