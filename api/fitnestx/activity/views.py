from rest_framework import generics, status
#from .utils import predict_sensor_data
from fitnestx.activity.models import ActivityGoal, SensorData
from .serializers import ActivityGoalSerializer, SensorDataSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone

# class SensorDataListCreateView(generics.ListCreateAPIView):
#     queryset = SensorData.objects.all()
#     serializer_class = SensorDataSerializer
    
#     def create(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)

#         validated_data = predict_sensor_data(serializer.validated_data)

#         serializer.save(user=request.user, date_and_time=validated_data['date_and_time'], predicted_activity=validated_data['predicted_activity'])

#         return Response(serializer.data, status=status.HTTP_201_CREATED)


class TodaysActivityGoalListView(generics.RetrieveUpdateAPIView):
    serializer_class = ActivityGoalSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        today = timezone.now().date()
        return ActivityGoal.objects.filter(user_id=user_id, date=today)

    def get_object(self):
        queryset = self.get_queryset()
        obj = queryset.first()
        if not obj:
            user_id = self.kwargs['user_id']
            default_data = {
                'user_id': user_id,
                'date': timezone.now().date(),
                'calories_burn': 0,
                'target_calories_burn': 0,
                'calories_burn_complete_staus': False,
                'steps': 0,
                'target_steps': 0,
                'steps_complete_staus': False,
                'running_distance': 0,
                'target_running_distance': 0,
                'running_distance_complete_staus': False,
                'flights_climbed': 0,
                'target_flights_climbed': 0,
                'flights_climbed_complete_staus': False,
                'is_completed': False
            }
            obj = ActivityGoal.objects.create(**default_data)
        return obj

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)