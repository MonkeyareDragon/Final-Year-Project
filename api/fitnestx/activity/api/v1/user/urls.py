from django.urls import include, path

app_name = "room.users"

urlpatterns = [
        path("users/", include("fitnestx.activity.urls", namespace="users-rooms")),
]