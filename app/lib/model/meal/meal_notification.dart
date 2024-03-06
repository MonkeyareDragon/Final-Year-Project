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
      required this.sendDatetime}){
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
