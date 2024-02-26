from rest_framework import generics, status
from .utils import predict_sensor_data
from fitnestx.activity.models import SensorData
from .serializers import SensorDataSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class SensorDataListCreateView(generics.ListCreateAPIView):
    queryset = SensorData.objects.all()
    serializer_class = SensorDataSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        validated_data = predict_sensor_data(serializer.validated_data)

        serializer.save(user=request.user, date_and_time=validated_data['date_and_time'], predicted_activity=validated_data['predicted_activity'])

        return Response(serializer.data, status=status.HTTP_201_CREATED)
