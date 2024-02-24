from rest_framework import serializers
from fitnestx.users.api.v1.serializers import UserSerializer
from fitnestx.activity.models import SensorData

class SensorDataSerializer(serializers.ModelSerializer):
    data = serializers.ListField(child=serializers.ListField(child=serializers.FloatField()))
    date_and_time = serializers.DateTimeField(read_only=True)

    class Meta:
        model = SensorData
        fields = '__all__'
        read_only_fields = ['date_and_time', 'predicted_activity']
