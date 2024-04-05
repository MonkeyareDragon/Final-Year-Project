from django.urls import path
from fitnestx.activity.views import CalculateBMIView, CalorieDataView, SensorDataListCreateView, StepCountDataView, TodaysActivityGoalListView

app_name = "activity.users"

urlpatterns = [
    path("predict/", SensorDataListCreateView.as_view(), name="sensor_data_list"),
    path('activity-goals/<int:user_id>/', TodaysActivityGoalListView.as_view(), name='todays-activity-goals'),
    path('calculate-bmi/', CalculateBMIView.as_view(), name='calculate_bmi'),
    path('step-data/', StepCountDataView.as_view(), name='step_data'),
    path('calorie-data/', CalorieDataView.as_view(), name='calorie_data'),
]
