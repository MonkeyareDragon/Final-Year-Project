from django.urls import path
from . import views

app_name = "dashboard"

urlpatterns = [
    path("", views.home, name="home"),
    path("login/", views.login_user, name="login"),
    path("logout/", views.logout_user, name="logout"),
    path("register/", views.register_user, name="register"),
    path('users/user/', views.redirect_to_user, name='users_user'),
    path('details/user/<int:pk>/', views.user_record, name='details'),
    path('delete_details/user/<int:pk>/', views.delete_user_record, name='delete_details'),
    path('users/user_profile/', views.redirect_to_user_profile, name='users_user_profile'),
    path('activity/activity_goal/', views.redirect_to_activity_goal, name='activity_activity_goal'),
    path('activity/sensor_data/', views.redirect_to_sensor_data, name='activity_sensor_data'),
    path('activity/sleep_tracking/', views.redirect_to_sleep_tracking, name='activity_sleep_tracking'),
    path('activity/water_intake/', views.redirect_to_water_intake, name='activity_water_intake'),
    path('meal/nutrition/', views.redirect_to_nutrition, name='meal_nutrition'), 
    path('meal/ingredient/', views.redirect_to_ingredient, name='meal_ingredient'),
    path('meal/food/', views.redirect_to_food, name='meal_food'),
    path('meal/category/', views.redirect_to_category, name='meal_category'),
    path('meal/meal/', views.redirect_to_meal, name='meal_meal'),
    path('meal/food_making_steps/', views.redirect_to_food_making_steps, name='meal_food_making_steps'),
    path('meal/food_schedule/', views.redirect_to_food_schedule, name='meal_food_schedule'),
    path('workout/equipment/', views.redirect_to_equipment, name='workout_equipment'),
    path('workout/exercise/', views.redirect_to_exercise, name='workout_exercise'),
    path('workout/exercise_perform/', views.redirect_to_exercise_perform, name='workout_exercise_perform'), 
    path('workout/workout/', views.redirect_to_workout, name='workout_workout'),
    path('workout/workout_exercise/', views.redirect_to_workout_exercise, name='workout_workout_exercise'),
    path('workout/workout_schedule/', views.redirect_to_workout_schedule, name='workout_workout_schedule'),
]
