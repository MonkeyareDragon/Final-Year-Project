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
    exercises = serializers.PrimaryKeyRelatedField(queryset=Exercise.objects.all(), many=True)
    equipments = serializers.PrimaryKeyRelatedField(queryset=Equipment.objects.all(), many=True)

    class Meta:
        model = Workout
        fields = '__all__'

class WorkoutExerciseSerializer(serializers.ModelSerializer):
    exercise_name = serializers.CharField(source='exercise.name')
    exercise_time_required = serializers.CharField(source='exercise.time_required')

    class Meta:
        model = WorkoutExercise
        fields = ['exercise_name', 'exercise_time_required', 'set_count']