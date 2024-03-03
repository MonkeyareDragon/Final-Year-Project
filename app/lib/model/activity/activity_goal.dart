class ActivityGoal {
  int id;
  DateTime date;
  int caloriesBurn;
  int targetCaloriesBurn;
  bool caloriesBurnCompleteStaus;
  int steps;
  int targetSteps;
  bool stepsCompleteStaus;
  String runningDistance;
  String targetRunningDistance;
  bool runningDistanceCompleteStaus;
  int flightsClimbed;
  int targetFlightsClimbed;
  bool flightsClimbedCompleteStaus;
  bool isCompleted;
  int user;

  ActivityGoal({
    required this.id,
    required this.date,
    required this.caloriesBurn,
    required this.targetCaloriesBurn,
    required this.caloriesBurnCompleteStaus,
    required this.steps,
    required this.targetSteps,
    required this.stepsCompleteStaus,
    required this.runningDistance,
    required this.targetRunningDistance,
    required this.runningDistanceCompleteStaus,
    required this.flightsClimbed,
    required this.targetFlightsClimbed,
    required this.flightsClimbedCompleteStaus,
    required this.isCompleted,
    required this.user,
  });

  factory ActivityGoal.fromJson(Map<String, dynamic> json) {
    return ActivityGoal(
      id: json['id'],
      date: DateTime.parse(json['date']),
      caloriesBurn: json['calories_burn'],
      targetCaloriesBurn: json['target_calories_burn'],
      caloriesBurnCompleteStaus: json['calories_burn_complete_staus'],
      steps: json['steps'],
      targetSteps: json['target_steps'],
      stepsCompleteStaus: json['steps_complete_staus'],
      runningDistance: json['running_distance'],
      targetRunningDistance: json['target_running_distance'],
      runningDistanceCompleteStaus: json['running_distance_complete_staus'],
      flightsClimbed: json['flights_climbed'],
      targetFlightsClimbed: json['target_flights_climbed'],
      flightsClimbedCompleteStaus: json['flights_climbed_complete_staus'],
      isCompleted: json['is_completed'],
      user: json['user'],
    );
  }
}
