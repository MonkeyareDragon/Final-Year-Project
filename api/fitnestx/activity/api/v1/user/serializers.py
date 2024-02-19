from rest_framework import serializers
from fitnestx.activity.models import SensorData

class SensorDataSerializer(serializers.Serializer):
    data = serializers.ListField(child=serializers.ListField(child=serializers.FloatField()))

    def create(self, validated_data):
        return SensorData.objects.create(data=validated_data['data'])
