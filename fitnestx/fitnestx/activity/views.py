from rest_framework import generics, status
from fitnestx.activity.models import ActivityGoal, SensorData
from fitnestx.activity.utils import get_bmi_condition, predict_sensor_data
from fitnestx.users.models import UserProfile
from .serializers import ActivityGoalSerializer, SensorDataSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import UpdateAPIView
from django.db.models import Count
from datetime import timedelta

class SensorDataListCreateView(generics.ListCreateAPIView):
    queryset = SensorData.objects.all()
    serializer_class = SensorDataSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        validated_data = predict_sensor_data(serializer.validated_data)

        serializer.save(user=request.user, date_and_time=validated_data['date_and_time'], predicted_activity=validated_data['predicted_activity'])

        return Response(serializer.data, status=status.HTTP_201_CREATED)

class TodaysActivityGoalListView(generics.RetrieveUpdateAPIView):
    serializer_class = ActivityGoalSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        current_datetime = timezone.localtime(timezone.now())
        current_date = current_datetime.date()
        return ActivityGoal.objects.filter(user_id=user_id, date=current_date)

    def get_object(self):
        queryset = self.get_queryset()
        obj = queryset.first()
        if not obj:
            user_id = self.kwargs['user_id']
            default_data = {
                'user_id': user_id,
                'date': timezone.localtime(timezone.now()).date(),
                'calories_burn': 0,
                'target_calories_burn': 15,
                'calories_burn_complete_staus': False,
                'steps': 0,
                'target_steps': 15,
                'steps_complete_staus': False,
                'running_distance': 0,
                'target_running_distance': 1,
                'running_distance_complete_staus': False,
                'flights_climbed': 0,
                'target_flights_climbed': 5,
                'flights_climbed_complete_staus': False,
                'is_completed': False
            }
            obj = ActivityGoal.objects.create(**default_data)
        return obj

    def get(self, request, *args, **kwargs):
        instance = self.get_object()

        # Explicitly invoke update methods to ensure model updates
        instance._update_calories_burn()
        instance._update_steps()
        instance._update_running_distance()
        instance._update_flights_climbed()
        instance._update_completion_status()

        instance.save()  # Save the updated instance

        serializer = self.get_serializer(instance)
        return Response(serializer.data)

class CalculateBMIView(APIView):
    
    def get(self, request, *args, **kwargs):
        try:
            profile = UserProfile.objects.get(user=request.user)
        except UserProfile.DoesNotExist:
            return Response({"error": "User profile not found"}, status=status.HTTP_404_NOT_FOUND)
        
        if profile.weight and profile.height:
            weight_in_kg = float(profile.weight)
            height_in_cm = float(profile.height)
            
            # Metric System
            height_in_m = height_in_cm / 100.0
            bmi = weight_in_kg / (height_in_m ** 2)
            bmi = round(bmi, 2)
            
            condition = get_bmi_condition(bmi)
            
            return Response({
                "bmi": bmi,
                "condition": condition
            }, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Weight or height not provided in user profile"}, status=status.HTTP_400_BAD_REQUEST)

class StepCountDataView(APIView):

    def get(self, request, *args, **kwargs):
        user = request.user
        current_datetime = timezone.localtime(timezone.now())
        start_time = current_datetime - timedelta(hours=24)
        step_count_data = {}

        for hour in range(24):
            hour_start = start_time + timedelta(hours=hour)
            hour_end = hour_start + timedelta(hours=1)

            step_count = SensorData.objects.filter(
                user=user,
                predicted_activity='Walking',
                date_and_time__gte=hour_start,
                date_and_time__lt=hour_end
            ).count()

            step_count_data[hour] = step_count

        return Response(step_count_data, status=status.HTTP_200_OK)
    
class CalorieDataView(APIView):

    def get(self, request, *args, **kwargs):
        user = request.user
        current_date = timezone.localtime(timezone.now()).date()

        try:
            activity_goal = ActivityGoal.objects.get(user=user, date=current_date)
            response_data = {
                "calories_burn": activity_goal.calories_burn,
                "target_calories_burn": activity_goal.target_calories_burn
            }

            return Response(response_data, status=status.HTTP_200_OK)

        except ActivityGoal.DoesNotExist:
            return Response({"error": "No data found for the current date"}, status=status.HTTP_404_NOT_FOUND)

class ActivityGoalTargetUpdateAPIView(UpdateAPIView):
    queryset = ActivityGoal.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = ActivityGoalSerializer
    lookup_field = 'pk'

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()

        target_fields = [
            'target_calories_burn',
            'target_steps',
            'target_running_distance',
            'target_flights_climbed'
        ]

        for field in target_fields:
            if field in request.data:
                setattr(instance, field, request.data[field])

        instance.save()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)