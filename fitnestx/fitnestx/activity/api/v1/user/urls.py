from django.urls import include, path

app_name = "users"

urlpatterns = [
        path("users/", include("fitnestx.activity.urls", namespace="users-activity")),
]