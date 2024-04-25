// meal.model.FoodSchedule
import 'package:loginsignup/controller/helper/url_helper.dart';

class MealNotification {
  String image;
  String notificationNote;
  String time;
  bool checkNotification;
  DateTime sendDatetime;

  MealNotification(
      {required this.image,
      required this.notificationNote,
      required this.time,
      required this.checkNotification,
      required this.sendDatetime}) {
    this.image = UrlUtil.getImageUrl(image);
  }

  factory MealNotification.fromJson(Map<String, dynamic> json) {
    return MealNotification(
      image: json['image'],
      notificationNote: json['notification_note'],
      time: json['time'],
      checkNotification: json['check_notification'],
      sendDatetime: DateTime.parse(json['send_datetime']),
    );
  }
}

class MealSchedule {
  String mealName;
  int totalCalorie;
  List<MealScheduleDetail> mealScheduleDetail;

  MealSchedule({
    required this.mealName,
    required this.totalCalorie,
    required this.mealScheduleDetail,
  });

  factory MealSchedule.fromJson(Map<String, dynamic> json) {
    return MealSchedule(
      mealName: json['meal_name'],
      totalCalorie: json['total_calories'],
      mealScheduleDetail: (json['details'] as List)
          .map((meal_schedule) => MealScheduleDetail.fromJson(meal_schedule))
          .toList(),
    );
  }
}

class MealScheduleDetail {
  String name;
  String time;
  String image;
  String status;
  int scheduleId;
  int requiredTime;
  bool notifyStatus;

  MealScheduleDetail({
    required this.name,
    required this.time,
    required this.image,
    required this.status,
    required this.scheduleId,
    required this.requiredTime,
    required this.notifyStatus,
  }) {
    this.image = UrlUtil.getImageUrl(image);
  }

  factory MealScheduleDetail.fromJson(Map<String, dynamic> json) {
    return MealScheduleDetail(
      name: json['name'],
      time: json['time'],
      image: json['image'],
      status: json['status'],
      scheduleId: json['schedule_id'],
      requiredTime: json['time_required'],
      notifyStatus: json['notify_status'],
    );
  }
}

class DailyMealScheduleNutritions {
  int totalcholesterol;
  int targetcholesterol;
  int totalVitaminc;
  int targetVitaminc;
  int totalFat;
  int targetFat;
  int totalCarbohydrate;
  int targetCarbohydrate;

  DailyMealScheduleNutritions({
    required this.totalcholesterol,
    required this.targetcholesterol,
    required this.totalVitaminc,
    required this.targetVitaminc,
    required this.totalFat,
    required this.targetFat,
    required this.totalCarbohydrate,
    required this.targetCarbohydrate,
  });

  factory DailyMealScheduleNutritions.fromJson(Map<String, dynamic> json) {
    return DailyMealScheduleNutritions(
      totalcholesterol: json['total_cholesterol'],
      targetcholesterol: json['target_cholesterol'],
      totalVitaminc: json['total_vitaminc'],
      targetVitaminc: json['target_vitaminc'],
      totalFat: json['total_fat'],
      targetFat: json['target_fat'],
      totalCarbohydrate: json['total_carbo'],
      targetCarbohydrate: json['target_carbo'],
    );
  }
}

class TodayMeal {
  String mealName;
  List<TodayMealDetail> details;

  TodayMeal({
    required this.mealName,
    required this.details,
  });

  factory TodayMeal.fromJson(Map<String, dynamic> json) {
    return TodayMeal(
      mealName: json['meal_name'],
      details: (json['details'] as List)
          .map((today_meal) => TodayMealDetail.fromJson(today_meal))
          .toList(),
    );
  }
}

class TodayMealDetail {
  String name;
  String image;
  String date;
  String time;
  bool notifyStatus;

  TodayMealDetail({
    required this.name,
    required this.image,
    required this.date,
    required this.time,
    required this.notifyStatus,
  }) {
    this.image = UrlUtil.getImageUrl(image);
  }

  factory TodayMealDetail.fromJson(Map<String, dynamic> json) {
    return TodayMealDetail(
      name: json['name'],
      image: json['image'],
      date: json['date'],
      time: json['time'],
      notifyStatus: json['notify_status'],
    );
  }
}

class ScheduleDetails {
  List<Schedule> schedules;

  ScheduleDetails({
    required this.schedules,
  });
  factory ScheduleDetails.fromJson(Map<String, dynamic> json) {
    return ScheduleDetails(
      schedules: (json['schedules'] as List)
          .map((schedule) => Schedule(
              id: schedule['id'],
              date: DateTime.parse(schedule['date']),
              time: schedule['time'],
              food: schedule['food'],
              notificationNote: schedule['notification_note'],
              status: schedule['status'],
              checkNotification: schedule['check_notification'],
              sendNotification: schedule['send_notification']))
          .toList(),
    );
  }
}

class Schedule {
  int id;
  DateTime date;
  String time;
  String food;
  String notificationNote;
  String status;
  bool checkNotification;
  bool sendNotification;

  Schedule({
    required this.id,
    required this.date,
    required this.time,
    required this.food,
    required this.notificationNote,
    required this.status,
    required this.checkNotification,
    required this.sendNotification,
  });
}
