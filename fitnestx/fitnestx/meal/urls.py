from django.urls import path
from fitnestx.meal.views import DailyNutritionDataView, DisplayFoodScheduleNotificationView, FoodIngredientDetails, FoodMakingStepsListView, FoodScheduleCreateAPIView, FoodScheduleDeleteAPIView, FoodScheduleStatusUpdateAPIView, MealRecBasedOnUserActivity, MealScheduleScreenDetailView, MealUpComingBarListView, SimilarFoodRecommendationView, UpdateFoodScheduleNotificationView, MealFoodDetails, MealList, CategoryList, NutritionOnFoodDetails, UpdateNotificationAPI, UserNotificationScheduleView, WeeklyProgressView

app_name = "meal.users"

urlpatterns = [
    path('meal-list/', MealList.as_view(), name='equipment-list'),
    path('categories/<int:meal_id>/', CategoryList.as_view(), name='category-list-filtered'),
    path('foods/<int:meal_id>/', MealFoodDetails.as_view(), name='food-list-filtered'),
    path('nutrition/<int:food_id>/', NutritionOnFoodDetails.as_view(), name='nutrition-list-filtered'),
    path('ingredient/<int:food_id>/', FoodIngredientDetails.as_view(), name='Ingredient-list-filtered'),
    path('food-making-steps/<int:food_id>/', FoodMakingStepsListView.as_view(), name='food-making-steps-list'),
    path('food-schedule/create/', FoodScheduleCreateAPIView.as_view(), name='food-schedule-create'),
    path('foodschedules/', UpdateFoodScheduleNotificationView.as_view({'get': 'list'}), name='foodschedules-update'),
    path('notifications/<int:user_id>/', DisplayFoodScheduleNotificationView.as_view(), name='food_schedule_notifications'),
    path('meals-schedule/user/<int:user_id>/date/<str:date>/', MealScheduleScreenDetailView.as_view(), name='meal-schedule-screen-detail'),
    path('schedule-nutrition/user/<int:user_id>/date/<str:date>/', DailyNutritionDataView.as_view(), name='user-daily-nutrition-data'),
    path('food-schedule/<int:pk>/complete/', FoodScheduleStatusUpdateAPIView.as_view(), name='food-schedule-complete'),
    path('food-schedule/<int:pk>/delete/', FoodScheduleDeleteAPIView.as_view(), name='food-schedule-delete'),
    path('meals/up-comming-bar/<int:user_id>/<str:date>/<str:time>/', MealUpComingBarListView.as_view(), name='meal-list'),
    path('weekly-progress/<int:user_id>/', WeeklyProgressView.as_view(), name='weekly_progress'),
    path('user/<int:user_id>/schedules/', UserNotificationScheduleView.as_view(), name='user_schedules'),
    path('meal/schedules/<int:schedule_id>/', UpdateNotificationAPI.as_view(), name='update_notification'),
    path('recommend/<int:food_id>/', SimilarFoodRecommendationView.as_view(), name='food_recommendation'),
    path('recommend-based-activity/<int:user_id>/<str:date>/', MealRecBasedOnUserActivity.as_view(), name='food_recommendation'),
]
