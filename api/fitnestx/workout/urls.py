from django.urls import path
from .views import EquipmentList, EquipmentDetail, ExerciseList, ExerciseDetail, WorkoutList, WorkoutDetail, WorkoutExerciseList, WorkoutExerciseDetail

app_name = "workout.users"

urlpatterns = [
    path('equipment/', EquipmentList.as_view(), name='equipment-list'),
    path('equipment/<int:pk>/', EquipmentDetail.as_view(), name='equipment-detail'),
    path('exercise/', ExerciseList.as_view(), name='exercise-list'),
    path('exercise/<int:pk>/', ExerciseDetail.as_view(), name='exercise-detail'),
    path('workout/', WorkoutList.as_view(), name='workout-list'),
    path('workout/<int:pk>/', WorkoutDetail.as_view(), name='workout-detail'),
    path('workout-exercise/', WorkoutExerciseList.as_view(), name='workout-exercise-list'),
    path('workout-exercise/<int:pk>/', WorkoutExerciseDetail.as_view(), name='workout-exercise-detail'),
]
