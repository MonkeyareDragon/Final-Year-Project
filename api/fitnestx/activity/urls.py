from django.urls import include, path

from .views import SensorDataListCreateView

app_name = "activity.users"

urlpatterns = [
    path("predict/", SensorDataListCreateView.as_view(), name="sensor_data_list"),
]
