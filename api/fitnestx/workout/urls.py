from django.urls import path
from .views import EquipmentList, EquipmentDetail, ExerciseList, ExerciseDetail, ExercisePerformDetails, ExercisePerformList, WorkoutEquipmentAPIView, WorkoutExerciseDetailsAPIView, WorkoutList, WorkoutDetail, WorkoutExerciseList, WorkoutExerciseDetail, WorkoutScheduleCreateAPIView, WorkoutScheduleDetailView

app_name = "workout.users"

urlpatterns = [
    path('equipment/', EquipmentList.as_view(), name='equipment-list'),
    path('equipment/<int:pk>/', EquipmentDetail.as_view(), name='equipment-detail'),
    path('exercise/', ExerciseList.as_view(), name='exercise-list'),
    path('exercise/<int:pk>/', ExerciseDetail.as_view(), name='exercise-detail'),
    path('exercise-perform/', ExercisePerformList.as_view(), name='exercise-list'),
    path('exercise-perform/<int:exercise_id>/', ExercisePerformDetails.as_view(), name='exercise_perform_api'),
    path('workout/', WorkoutList.as_view(), name='workout-list'),
    path('workout/<int:pk>/', WorkoutDetail.as_view(), name='workout-detail'),
    path('workout-exercise/', WorkoutExerciseList.as_view(), name='workout-exercise-list'),
    path('workout-exercise/<int:workout_id>/', WorkoutExerciseDetail.as_view(), name='workout-exercise-detail'),
    path('workout/<int:workout_id>/exercises-details/', WorkoutExerciseDetailsAPIView.as_view(), name='workout-exercises'),
    path('workout/<int:workout_id>/equipments/', WorkoutEquipmentAPIView.as_view(), name='workout-equipment'),
    path('workout-schedule/create/', WorkoutScheduleCreateAPIView.as_view(), name='workout-schedule-create'),
    path('workout-schedule/user/<int:user_id>/date/<str:date>/', WorkoutScheduleDetailView.as_view(), name='workout-schedule-detail'),
]
