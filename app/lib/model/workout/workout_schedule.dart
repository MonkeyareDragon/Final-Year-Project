class WorkSchedule {
  String? date;
  String? time;
  String? workoutName;
  String? userUsername;
  String? notificationNote;
  bool? notifyStatus;
  String? status;
  bool? checkNotification;
  bool? sendNotification;

  WorkSchedule(
      {this.date,
      this.time,
      this.workoutName,
      this.userUsername,
      this.notificationNote,
      this.notifyStatus,
      this.status,
      this.checkNotification,
      this.sendNotification});

  WorkSchedule.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    workoutName = json['workout_name'];
    userUsername = json['user_username'];
    notificationNote = json['notification_note'];
    notifyStatus = json['notify_status'];
    status = json['status'];
    checkNotification = json['check_notification'];
    sendNotification = json['send_notification'];
  }
}