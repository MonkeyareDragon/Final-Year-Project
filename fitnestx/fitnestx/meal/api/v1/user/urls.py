from django.urls import include, path

app_name = "meal.users"

urlpatterns = [
        path("users/", include("fitnestx.meal.urls", namespace="users-meal")),
]