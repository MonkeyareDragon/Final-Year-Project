from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from rest_framework.generics import ListAPIView
from django.http import JsonResponse
from django.views.generic import View
from datetime import datetime
from fitnestx.users.models import User
from .models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise, WorkoutSchedule
from .serializers import EquipmentSerializer, ExercisePerformSerializer, ExerciseSerializer, WorkoutExerciseSetSerializer, WorkoutScheduleSerializer, WorkoutSerializer

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
    
class ExercisePerformDetails(APIView):
    def get(self, request, exercise_id, *args, **kwargs):
        try:
            exercise_performs = ExercisePerform.objects.filter(exercises__id=exercise_id)
            serializer = ExercisePerformSerializer(exercise_performs, many=True)
            return Response(serializer.data)
        
        except ExercisePerform.DoesNotExist:
            return Response({"message": "ExercisePerform not found"}, status=404)

class WorkoutList(generics.ListAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

class WorkoutDetail(generics.RetrieveAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

class WorkoutExerciseList(generics.ListAPIView):
    queryset = WorkoutExercise.objects.all()
    serializer_class = WorkoutExerciseSetSerializer

class WorkoutExerciseDetailsAPIView(ListAPIView):
    serializer_class = ExercisePerformSerializer

    def get_queryset(self):
        exercise_id = self.kwargs['exercise_id']
        return ExercisePerform.objects.filter(exercises__id=exercise_id)

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

class WorkoutScheduleCreateAPIView(generics.CreateAPIView):
    queryset = WorkoutSchedule.objects.all()
    serializer_class = WorkoutScheduleSerializer

class UserWorkoutScheduleView(View):
    def get(self, request, user_id, *args, **kwargs):
        user = get_object_or_404(User, id=user_id)
        workout_schedules = WorkoutSchedule.objects.filter(user=user)
        
        response_data = []
        
        for schedule in workout_schedules:
            start_time = datetime.combine(schedule.date, schedule.time).strftime("%d/%m/%Y %I:%M %p")
            data = {
                "workout_id": schedule.workout.id,
                "name": schedule.workout.name,
                "start_time": start_time,
            }
            response_data.append(data)
        
        return JsonResponse(response_data, safe=False)