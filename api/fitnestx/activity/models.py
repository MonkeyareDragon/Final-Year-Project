from django.db import models
from fitnestx.users.models import User

class SensorData(models.Model):
    user = models.ForeignKey(User, related_name='user_id', on_delete=models.CASCADE)
    data = models.JSONField()
    date_and_time = models.DateTimeField()
    predicted_activity = models.CharField(max_length=10)

class ActivityGoal(models.Model):
    user = models.ForeignKey(User, related_name='activity_user_id', on_delete=models.CASCADE)
    calories_burn = models.PositiveIntegerField(default=0)
    steps = models.PositiveIntegerField(default=0)
    running_distance = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    flights_climbed = models.PositiveIntegerField(default=0)