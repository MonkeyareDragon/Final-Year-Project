from rest_framework import serializers
from fitnestx.activity.utils import calculate_calories_burned
from fitnestx.users.models import UserProfile
from fitnestx.activity.models import ActivityGoal, SensorData
from datetime import date
from django.utils import timezone

class SensorDataSerializer(serializers.ModelSerializer):
    data = serializers.ListField(child=serializers.ListField(child=serializers.FloatField()))
    date_and_time = serializers.DateTimeField(read_only=True)

    class Meta:
        model = SensorData
        fields = '__all__'
        read_only_fields = ['date_and_time', 'predicted_activity']

class ActivityGoalSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivityGoal
        fields = '__all__'