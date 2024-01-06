from django.db import models

class SensorData(models.Model):
    data = models.JSONField()
