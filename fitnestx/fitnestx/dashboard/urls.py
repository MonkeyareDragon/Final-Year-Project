from django.urls import path
from . import views

app_name = "dashboard"

urlpatterns = [
    path("", views.home, name="home"),
    path("login/", views.login_user, name="login"),
    path("logout/", views.logout_user, name="logout"),
    path("register/", views.register_user, name="register"),
    path('users/user/', views.redirect_to_user, name='users_user'),
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
    path('charts/user_stats/', views.chart_user_stats, name='chart_user_stats'),
    path('export-csv/', views.export_to_csv_food_details, name='export_to_csv_food_details'),
    path('export-food-schedule/', views.export_food_schedule_to_csv, name='export_food_schedule_to_csv'),
    path('delete_user/<int:user_id>/', views.delete_user, name='delete_user'),
    path('edit_user/<int:user_id>/', views.edit_user, name='edit_user'),
    path('delete_user_profile/<int:profile_id>/', views.delete_user_profile, name='delete_user_profile'),
    path('edit_user_profile/<int:profile_id>/', views.edit_user_profile, name='edit_user_profile'),
    path('delete_food/<int:food_id>/', views.delete_food, name='delete_food'),
    path('edit_food/<int:food_id>/', views.edit_food, name='edit_food'),
    path('add_food/', views.add_food, name='add_food'),
    path('add_category/', views.add_category, name='add_category'),
    path('delete_category/<int:category_id>/', views.delete_category, name='delete_category'),
    path('edit_category/<int:category_id>/', views.edit_category, name='edit_category'),
    path('delete_food_schedule/<int:meal_schedule_id>/', views.delete_meal_schedule, name='delete_food_schedule'),
    path('edit_food_schedule/<int:meal_schedule_id>/', views.edit_food_schedule, name='edit_food_schedule'),
    path('add_equipment/', views.add_equipment, name='add_equipment'),
    path('add_exercise/', views.add_exercise, name='add_exercise'),
    path('add_workout/', views.add_workout, name='add_workout'),
    path('add_exercise_perform/', views.add_exercise_perform, name='add_exercise_perform'),
    path('delete_food/<int:food_id>/', views.delete_food, name='delete_food'),
    path('edit_food/<int:food_id>/', views.edit_food, name='edit_food'),
    path('delete_equipment/<int:equipment_id>/', views.delete_equipment, name='delete_equipment'),
    path('edit_equipment/<int:equipment_id>/', views.edit_equipment, name='edit_equipment'),
    path('delete_exercise/<int:exercise_id>/', views.delete_exercise, name='delete_exercise'),
    path('edit_exercise/<int:exercise_id>/', views.edit_exercise, name='edit_exercise'),
    path('delete_exerciseperform/<int:perform_id>/', views.delete_exerciseperform, name='delete_exerciseperform'),
    path('edit_exerciseperform/<int:perform_id>/', views.edit_exerciseperform, name='edit_exerciseperform'),
    path('delete_workout/<int:workout_id>/', views.delete_workout, name='delete_workout'),
    path('edit_workout/<int:workout_id>/', views.edit_workout, name='edit_workout'),
    path('delete_workout_exercise/<int:workout_exercise_id>/', views.delete_workout_exercise, name='delete_workout_exercise'),
    path('edit_workout_exercise/<int:workout_exercise_id>/', views.edit_workout_exercise, name='edit_workout_exercise'),
    path('delete_workout_schedule/<int:workout_schedule_id>/', views.delete_workout_schedule, name='delete_workout_schedule'),
    path('edit_workout_schedule/<int:workout_schedule_id>/', views.edit_workout_schedule, name='edit_workout_schedule'),
    path('add_nutrition/', views.add_nutrition, name='add_nutrition'),
    path('add_ingredient/', views.add_ingredient, name='add_ingredient'),
    path('add_meal/', views.add_meal, name='add_meal'),
    path('add_food_making_steps/', views.add_food_making_steps, name='add_food_making_steps'),
    path('food-details/', views.food_data_list, name='food_data_list'),
    path('delete_meal/<int:meal_id>/', views.delete_meal, name='delete_meal'),
    path('edit_meal/<int:meal_id>/', views.edit_meal, name='edit_meal'),
]
