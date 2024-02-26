class WorkoutExercise {
  final int id;
  final int workoutId;
  final int exerciseId;
  final int setCount;

  WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.setCount,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      workoutId: json['workout'],
      exerciseId: json['exercise'],
      setCount: json['set_count'],
    );
  }
}