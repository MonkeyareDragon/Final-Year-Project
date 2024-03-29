from django.urls import include, path

app_name = "workout.users"

urlpatterns = [
        path("users/", include("fitnestx.workout.urls", namespace="users-workout")),
]