from rest_framework import generics, permissions, status
from fitnestx.activity.models import SensorData
from .serializers import SensorDataSerializer
from rest_framework.response import Response
import numpy as np
import tensorflow as tf
import config.settings.base as settings

model = tf.keras.models.load_model(settings.MODEL_FILEPATH)

def predict_sensor_data(sensor_data):

    data = np.array(sensor_data['data'])  # Convert to NumPy array
    data = np.expand_dims(data, axis=0)   # Add batch dimension

    # Make predictions
    predictions = model.predict(data)

    class_labels = {0: 'Walking', 1: 'Jogging', 2: 'Stairs', 3: 'Sitting', 4: 'Standing'}
    
    predicted_class_index = np.argmax(predictions)
    predicted_class_label = class_labels[predicted_class_index]

    return predicted_class_label

class SensorDataListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.AllowAny]
    queryset = SensorData.objects.all()
    serializer_class = SensorDataSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Make predictions using the loaded Keras model
        predicted_class = predict_sensor_data(serializer.validated_data)

        return Response({'predicted_activity': predicted_class}, status=status.HTTP_201_CREATED)