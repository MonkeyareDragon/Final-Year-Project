class WeeklyMealProgress {
  String weeklyDay;
  double progress;

  WeeklyMealProgress({
    required this.weeklyDay,
    required this.progress,
  });
  factory WeeklyMealProgress.fromJson(Map<String, dynamic> json) {
    return WeeklyMealProgress(
      weeklyDay: json['weekly_day'],
      progress: json['progress'].toDouble(),
    );
  }
}