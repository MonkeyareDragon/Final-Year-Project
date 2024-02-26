from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.generics import ListAPIView
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
    serializer_class = WorkoutExerciseSerializer

    def get_queryset(self):
        workout_id = self.kwargs.get('workout_id')
        print(workout_id)
        return WorkoutExercise.objects.filter(workout__id=workout_id)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if queryset.exists():
            serializer = self.get_serializer(queryset, many=True)
            return Response(data=serializer.data, status=status.HTTP_200_OK)
        else:
            return Response(data={"detail": "No Workout Exercises found for the given workout_id"}, status=status.HTTP_404_NOT_FOUND)