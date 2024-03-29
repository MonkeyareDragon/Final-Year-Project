from django.contrib import admin
from .models import ActivityGoal, SensorData, SleepTracking, WaterIntake

class SensorDataAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'date_and_time', 'predicted_activity']
    search_fields = ['user__username', 'predicted_activity']
    list_filter = ['predicted_activity']

class ActivityGoalAdmin(admin.ModelAdmin):
    list_display = ('user', 'calories_burn', 'steps', 'running_distance', 'flights_climbed', 'is_completed')
    list_filter = ('user',)
    search_fields = ('user__username',)

class SleepTrackingAdmin(admin.ModelAdmin):
    list_display = ('user', 'sleep_start_time', 'sleep_end_time', 'sleep_duration', 'sleep_quality', 'notify')
    list_filter = ('user', 'sleep_quality', 'notify')
    search_fields = ('user__username',)

class WaterIntakeAdmin(admin.ModelAdmin):
    list_display = ('user', 'date_time', 'quantity', 'notify')
    list_filter = ('user',)
    search_fields = ('user__username',)

admin.site.register(SensorData, SensorDataAdmin)
admin.site.register(ActivityGoal, ActivityGoalAdmin)
admin.site.register(SleepTracking, SleepTrackingAdmin)
admin.site.register(WaterIntake, WaterIntakeAdmin)