from rest_framework import generics
from .models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise
from .serializers import EquipmentSerializer, ExercisePerformSerializer, ExerciseSerializer, WorkoutSerializer, WorkoutExerciseSerializer

class EquipmentList(generics.ListAPIView):
    queryset = Equipment.objects.all()
    serializer_class = EquipmentSerializer

class EquipmentDetail(generics.RetrieveAPIView):
    queryset = Equipment.objects.all()
    serializer_class = EquipmentSerializer

class ExerciseList(generics.ListAPIView):
    queryset = Exercise.objects.all()
    serializer_class = ExerciseSerializer

class ExerciseDetail(generics.RetrieveAPIView):
    queryset = Exercise.objects.all()
    serializer_class = ExerciseSerializer

class ExercisePerformList(generics.ListAPIView):
    queryset = ExercisePerform.objects.all()
    serializer_class = ExercisePerformSerializer
    
class ExercisePerformDetails(generics.RetrieveAPIView):
    queryset = ExercisePerform.objects.all()
    serializer_class = ExercisePerformSerializer

class WorkoutList(generics.ListAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

class WorkoutDetail(generics.RetrieveAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

class WorkoutExerciseList(generics.ListAPIView):
    queryset = WorkoutExercise.objects.all()
    serializer_class = WorkoutExerciseSerializer

class WorkoutExerciseDetail(generics.RetrieveAPIView):
    queryset = WorkoutExercise.objects.all()
    serializer_class = WorkoutExerciseSerializer