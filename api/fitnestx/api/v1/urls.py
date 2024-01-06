from django.urls import include, path

app_name = "api_v1"

urlpatterns = [
    path("users/", include("fitnestx.users.api.v1.urls", namespace="users")),
    path("model/", include("fitnestx.mod.api.v1.users.urls", namespace="model")),
]
