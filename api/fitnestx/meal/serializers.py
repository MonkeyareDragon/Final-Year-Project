from rest_framework import serializers
from fitnestx.meal.models import Food, FoodMakingSteps, FoodSchedule, Ingredient, Meal, Category, Nutrition

class MealSerializer(serializers.ModelSerializer):
    class Meta:
        model = Meal
        fields = '__all__'
        
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields = '__all__'

class NutritionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Nutrition
        fields = '__all__'

class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = '__all__'

class FoodMakingStepsSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodMakingSteps
        fields = '__all__'

class FoodScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodSchedule
        fields = '__all__'

class UpdateFoodScheduleNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodSchedule
        fields = ['notification_note', 'notify_status']