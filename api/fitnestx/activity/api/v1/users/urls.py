from django.urls import include, path

from fitnestx.activity.api.v1.users.views import SensorDataListCreateView

#from fitnestx.mod.api.v1.users.views import 

app_name = "mod.users"

urlpatterns = [
    path("predict/", SensorDataListCreateView.as_view(), name="sensor_data_list"),
]
