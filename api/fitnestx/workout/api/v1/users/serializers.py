from rest_framework import serializers
from fitnestx.workout.models import Equipment, Exercise, ExerciseSteps, Workout

class WorkoutSerializer(serializers.ModelSerializer):
    exercise = serializers.ReadOnlyField(source='get_exercise_display')
    
    class Meta:
        model = Workout
        fields = ['name', 'time', 'calories', 'difficulty', 'workout_exercises']
    
    def create(self, validated_data):
        """ Create a new hotel 
        from the validated data. """
        exercise_data = validated_data.pop('workout')
        
        workout =  Workout.objects.create(**validated_data)
        workout.facility.set(exercise_data)
        
        return workout
