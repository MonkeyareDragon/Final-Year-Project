from django.db import models
from fitnestx.users.models import User

class SensorData(models.Model):
    user = models.ForeignKey(User, related_name='user_id', on_delete=models.CASCADE)
    data = models.JSONField()
    date_and_time = models.DateTimeField()
    predicted_activity = models.CharField(max_length=10)
