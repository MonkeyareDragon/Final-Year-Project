from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from rest_framework.generics import ListAPIView
from django.http import JsonResponse
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

class WorkoutScheduleCreateAPIView(generics.CreateAPIView):
    queryset = WorkoutSchedule.objects.all()
    serializer_class = WorkoutScheduleSerializer

class WorkoutScheduleDetailView(APIView):
    def get(self, request, user_id, date):
        workout_schedules = WorkoutSchedule.objects.filter(user__id=user_id, date=date)
        
        data = []
        for workout_schedule in workout_schedules:
            data.append({
                'date': workout_schedule.date,
                'time': workout_schedule.time,
                'workout_name': workout_schedule.workout.name,
                'user_username': workout_schedule.user.username,
                'notification_note': workout_schedule.notification_note,
                'notify_status': workout_schedule.notify_status,
                'status': workout_schedule.status,
                'check_notification': workout_schedule.check_notification,
                'send_notification': workout_schedule.send_notification,
            })
        
        return JsonResponse(data, safe=False)