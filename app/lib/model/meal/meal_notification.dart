// meal.model.FoodSchedule
import 'package:loginsignup/common/url_helper.dart';

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
  }){
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
  int totalCalorie;
  int targetCalorie;
  int totalProtein;
  int targetProtein;
  int totalFat;
  int targetFat;
  int totalCarbohydrate;
  int targetCarbohydrate;

  DailyMealScheduleNutritions({
    required this.totalCalorie,
    required this.targetCalorie,
    required this.totalProtein,
    required this.targetProtein,
    required this.totalFat,
    required this.targetFat,
    required this.totalCarbohydrate,
    required this.targetCarbohydrate,
  });

  factory DailyMealScheduleNutritions.fromJson(Map<String, dynamic> json) {
    return DailyMealScheduleNutritions(
      totalCalorie: json['total_calorie'],
      targetCalorie: json['target_calorie'],
      totalProtein: json['total_protein'],
      targetProtein: json['target_protein'],
      totalFat: json['total_fat'],
      targetFat: json['target_fat'],
      totalCarbohydrate: json['total_carbo'],
      targetCarbohydrate: json['target_carbo'],
    );
  }
}
