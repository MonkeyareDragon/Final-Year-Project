from django.urls import include, path
from fitnestx.workout.api.v1.users.views import WorkoutViewSet

app_name = "workout.users"

urlpatterns = [
    # path("exercise-steps/", ExerciseStepsViewSet.as_view({'post': 'create'}), name="workout_steps"),
    # path("equipment/", EquipmentViewSet.as_view({'post': 'create'}), name="equipment_list"),
    # path("exercise/", ExerciseViewSet.as_view({'post': 'create'}), name="exercise_list"),
    path("workout-create/", WorkoutViewSet.as_view({'post': 'create'}), name="equipment_list"),
]