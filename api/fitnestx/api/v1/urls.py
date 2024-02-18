from django.urls import include, path

app_name = "api_v1"

urlpatterns = [
    path("users/", include("fitnestx.users.api.v1.urls", namespace="users")),
    path("model/", include("fitnestx.activity.api.v1.users.urls", namespace="model")),
    path("workout/", include("fitnestx.workout.api.v1.users.urls", namespace="model")),
]
