from rest_framework import serializers
from .models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise

class EquipmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Equipment
        fields = '__all__'

class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = '__all__'

class ExercisePerformSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExercisePerform
        fields = '__all__'
        
class WorkoutSerializer(serializers.ModelSerializer):
    exercises = ExerciseSerializer(many=True)
    equipments = EquipmentSerializer(many=True)
    class Meta:
        model = Workout
        fields = '__all__'

class WorkoutExerciseSetSerializer(serializers.ModelSerializer):
    set = serializers.SerializerMethodField()

    class Meta:
        model = WorkoutExercise
        fields = ['set_count', 'set']

    def get_set(self, obj):
        exercises = Exercise.objects.filter(workoutexercise__workout=obj.workout, workoutexercise__set_count=obj.set_count)
        exercise_data = []
        for exercise in exercises:
            exercise_data.append({
                "exercise_image": exercise.exercise_image.url,
                "exercise_name": exercise.name,
                "exercise_time_required": exercise.time_required
            })
        return exercise_data