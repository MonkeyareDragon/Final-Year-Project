from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.generics import ListAPIView
from .models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise
from .serializers import EquipmentSerializer, ExercisePerformSerializer, ExerciseSerializer, WorkoutExerciseSetSerializer, WorkoutSerializer

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
    serializer_class = WorkoutExerciseSetSerializer

class WorkoutExerciseDetailsAPIView(APIView):
    def get(self, request, workout_id, *args, **kwargs):
        try:
            workout = Workout.objects.get(pk=workout_id)
            exercises = workout.exercises.all()
            serializer = ExerciseSerializer(exercises, many=True)
            return Response(serializer.data)
        except Workout.DoesNotExist:
            return Response({"message": "Workout not found"}, status=404)

class WorkoutEquipmentAPIView(APIView):
    def get(self, request, workout_id, *args, **kwargs):
        try:
            workout = Workout.objects.get(pk=workout_id)
            equipment = workout.equipments.all()
            serializer = EquipmentSerializer(equipment, many=True)
            return Response(serializer.data)
        except Workout.DoesNotExist:
            return Response({"message": "Workout not found"}, status=404)

class WorkoutExerciseDetail(ListAPIView):
    serializer_class = WorkoutExerciseSetSerializer

    def get_queryset(self):
        workout_id = self.kwargs.get('workout_id')
        return WorkoutExercise.objects.filter(workout_id=workout_id).distinct('set_count')