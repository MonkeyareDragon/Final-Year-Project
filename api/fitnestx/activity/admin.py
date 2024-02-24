from django.contrib import admin
from .models import SensorData

@admin.register(SensorData)
class SensorDataAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'date_and_time', 'predicted_activity']
    search_fields = ['user__username', 'predicted_activity']
    list_filter = ['predicted_activity']