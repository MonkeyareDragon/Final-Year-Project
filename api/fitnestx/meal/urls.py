from django.urls import path
from fitnestx.meal.views import FoodMakingStepsListView, IngredientOnFoodDetails, MealFoodDetails, MealList, CategoryList, NutritionOnFoodDetails

app_name = "meal.users"

urlpatterns = [
    path('meal-list/', MealList.as_view(), name='equipment-list'),
    path('categories/<int:meal_id>/', CategoryList.as_view(), name='category-list-filtered'),
    path('foods/<int:meal_id>/', MealFoodDetails.as_view(), name='food-list-filtered'),
    path('nutrition/<int:food_id>/', NutritionOnFoodDetails.as_view(), name='nutrition-list-filtered'),
    path('ingredient/<int:food_id>/', IngredientOnFoodDetails.as_view(), name='Ingredient-list-filtered'),
    path('food-making-steps/<int:food_id>/', FoodMakingStepsListView.as_view(), name='food-making-steps-list'),
]
