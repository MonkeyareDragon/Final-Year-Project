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

  MealScheduleDetail({
    required this.name,
    required this.time,
    required this.image,
    required this.status,
    required this.scheduleId,
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
    );
  }
}
