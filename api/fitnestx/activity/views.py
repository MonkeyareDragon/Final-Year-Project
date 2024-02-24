from rest_framework import generics, permissions, status
from fitnestx.activity.models import SensorData
from .serializers import SensorDataSerializer
from rest_framework.response import Response
import numpy as np
import tensorflow as tf
from datetime import datetime
import config.settings.base as settings
from rest_framework.permissions import IsAuthenticated

model = tf.keras.models.load_model(settings.MODEL_FILEPATH)

def predict_sensor_data(sensor_data):
    data = np.array(sensor_data['data'])  # Convert to NumPy array
    data = np.expand_dims(data, axis=0)   # Add batch dimension

    # Make predictions
    predictions = model.predict(data)

    class_labels = {0: 'Walking', 1: 'Jogging', 2: 'Stairs', 3: 'Sitting', 4: 'Standing'}

    predicted_class_index = np.argmax(predictions)
    predicted_class_label = class_labels[predicted_class_index]

    # Set the predicted activity and current date and time
    sensor_data['predicted_activity'] = predicted_class_label
    sensor_data['date_and_time'] = datetime.now()

    return sensor_data

class SensorDataListCreateView(generics.ListCreateAPIView):
    queryset = SensorData.objects.all()
    serializer_class = SensorDataSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        validated_data = predict_sensor_data(serializer.validated_data)

        serializer.save(user=request.user, date_and_time=validated_data['date_and_time'], predicted_activity=validated_data['predicted_activity'])

        return Response(serializer.data, status=status.HTTP_201_CREATED)
