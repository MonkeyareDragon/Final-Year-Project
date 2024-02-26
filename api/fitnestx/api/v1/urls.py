from django.urls import include, path

app_name = "api_v1"

urlpatterns = [
    path("users/", include("fitnestx.users.api.v1.urls", namespace="users")),
    path("activity/", include("fitnestx.activity.api.v1.user.urls", namespace="activity-user")),
    # path("meal/user/", include("fitnestx.meal.api.v1.user.urls", namespace="meal-user")),
    # path("meal/admin/", include("fitnestx.meal.api.v1.admin.urls", namespace="meal-admin")),
    path("workout/", include("fitnestx.workout.api.v1.user.urls", namespace="workout-user")),
    # path("workout/admin/", include("fitnestx.workout.api.v1.admin.urls", namespace="workout-admin")),
    path("dashboard/", include("fitnestx.dashboard.urls", namespace="dashboard")),
]
