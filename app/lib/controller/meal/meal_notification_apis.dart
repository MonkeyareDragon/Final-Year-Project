import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginsignup/common/sesson_helper.dart';
import 'package:loginsignup/controller/helper/url_helper.dart';
import 'package:loginsignup/model/meal/meal_notification.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/model/session/user_session.dart';

Future<bool> createFoodSchedule(Map<String, dynamic> requestData) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final http.Response response = await http.post(
      ApiUrlHelper.buildUrl('meal/users/food-schedule/create/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      print('FoodSchedule created successfully');
      return true;
    } else {
      print(
          'Failed to create FoodSchedule. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error creating FoodSchedule: $e');
    throw Exception('Failed to create FoodSchedule: $e');
  }
}

// API call to fetch all the data of meal notification based on user id
Future<List<MealNotification>> fetchMealNotificationsOnUserID(int id) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/notifications/$id/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MealNotification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meal notification');
    }
  } catch (e) {
    print('Error fetching meal notification: $e');
    throw Exception('Failed to fetch meal notification: $e');
  }
}

// API call to fetch all the data of meal schedule details based on user id
Future<List<MealSchedule>> fetchMealSchedulerDetailsOnUserID(
    int id, String requiredDate) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl(
          'meal/users/meals-schedule/user/$id/date/$requiredDate/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<MealSchedule> mealSchedule = [];
      for (var data in responseData) {
        if (data['details'] != null && data['details'] is List) {
          mealSchedule.add(MealSchedule.fromJson(data));
        }
      }

      return mealSchedule;
    } else {
      throw Exception('Failed to load meal schedule details');
    }
  } catch (e) {
    print('Error fetching meal schedule details: $e');
    throw Exception('Failed to fetch meal schedule details: $e');
  }
}

// API call to fetch all the data of meal schedule nurition details based on user id
Future<DailyMealScheduleNutritions> fetchDailyMealSchedulerNutritionOnUserID(
    int id, String requiredDate) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl(
          'meal/users/schedule-nutrition/user/$id/date/$requiredDate/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return DailyMealScheduleNutritions.fromJson(
          data); // Return a single ActivityGoal object
    } else {
      throw Exception('Failed to load meal schedule nurition details');
    }
  } catch (e) {
    print('Error fetching meal schedule nurition details: $e');
    throw Exception('Failed to fetch meal schedule nurition details: $e');
  }
}

// API call to patch all the status of the meal schedule
Future<void> patchMealSchedulerStatus(int scheduleid, double rating) async {
  try {
    final UserSession session = await getSessionOrThrow();
    var requestData = {
      'rating': rating,
    };
    final response = await http.patch(
      ApiUrlHelper.buildUrl('meal/users/food-schedule/$scheduleid/complete/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Meal schedule status updated successfully');
    }
    if (response.statusCode == 403) {
      print('Forbidden to update meal schedule status');
    } else {
      print(
          'Failed to update meal schedule status. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error updating meal schedule status: $e');
    throw Exception('Failed to update meal schedule status: $e');
  }
}

// API call to delete the given id of the meal schedule
Future<void> deleteMealScheduler(int scheduleid) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.delete(
      ApiUrlHelper.buildUrl('meal/users/food-schedule/$scheduleid/delete/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 204) {
      print('Meal schedule have successfully deleted');
    } else if (response.statusCode == 403) {
      print('Forbidden to delete this meal schedule');
    } else {
      print(
          'Failed to delete meal schedule. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error deleting meal schedule status: $e');
    throw Exception('Failed to deleting meal schedule status: $e');
  }
}

// API call to fetch all the data of meal details which are schedule today
Future<List<TodayMeal>> fetchTodayScheduleMeals(
    int id, String requiredDate, String requestTime) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl(
          'meal/users/meals/up-comming-bar/$id/$requiredDate/$requestTime/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      List<TodayMeal> todayScheduleMeal = [];
      for (var data in responseData) {
        if (data['details'] != null && data['details'] is List) {
          todayScheduleMeal.add(TodayMeal.fromJson(data));
        }
      }

      return todayScheduleMeal;
    } else {
      throw Exception('Failed to load meal details which are schedule today');
    }
  } catch (e) {
    print('Error fetching meal details which are schedule today: $e');
    throw Exception(
        'Failed to fetch meal details which are schedule today: $e');
  }
}

Future<void> checkMealNotification(int userId) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.get(
      ApiUrlHelper.buildUrl('meal/users/user/$userId/schedules/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      for (var data in responseData) {
        if (data['schedules'] != null && data['schedules'] is List) {
          for (var schedule in data['schedules']) {
            DateTime currentDate = DateTime.now();
            DateTime scheduleDate = DateTime.parse(schedule['date']);
            TimeOfDay scheduleTime =
                TimeOfDay.fromDateTime(DateTime.parse(schedule['time']));
            TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);

            if (scheduleDate.isBefore(currentDate) ||
                (scheduleDate.isAtSameMomentAs(currentDate) &&
                    currentTime.hour > scheduleTime.hour) ||
                (scheduleDate.isAtSameMomentAs(currentDate) &&
                    currentTime.hour == scheduleTime.hour &&
                    currentTime.minute > scheduleTime.minute)) {
              String notificationMessage =
                  "Hello ${schedule['user']['username']}, it's time for your scheduled meal: ${schedule['food']['name']}.";
              await updateNotificationAPI(schedule['id'], notificationMessage);
            }
          }
        }
      }
    } else {
      throw Exception(
          'Failed to load meal details which are scheduled: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error updating notification: $e');
    throw Exception('Failed to update notification: $e');
  }
}

Future<void> updateNotificationAPI(
    int scheduleId, String notificationMessage) async {
  try {
    final UserSession session = await getSessionOrThrow();
    final response = await http.put(
      ApiUrlHelper.buildUrl('meal/schedules/$scheduleId/'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'notification_note': notificationMessage,
        'notify_status': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update notification status: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error updating notification status: $e');
    throw Exception('Failed to update notification status: $e');
  }
}
