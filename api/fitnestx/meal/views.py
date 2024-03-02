from rest_framework import generics, status
from fitnestx.meal.models import Food, FoodMakingSteps, Meal
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from fitnestx.meal.serializers import CategorySerializer, FoodMakingStepsSerializer, FoodSerializer, IngredientSerializer, MealSerializer, NutritionSerializer

class MealList(generics.ListAPIView):
    queryset = Meal.objects.all()
    serializer_class = MealSerializer

class CategoryList(APIView):
    def get(self, request, meal_id, *args, **kwargs):
        try:
            meal = Meal.objects.get(pk=meal_id)
            category = meal.categorys.all()
            serializer = CategorySerializer(category, many=True)
            return Response(serializer.data)
        except Meal.DoesNotExist:
            return Response({"message": "Meal not found"}, status=404)

class MealFoodDetails(APIView):
    def get(self, request, meal_id, *args, **kwargs):
        try:
            meal = Meal.objects.get(pk=meal_id)
            categories = meal.categorys.all()
            foods = Food.objects.filter(category__in=categories)
            serializer = FoodSerializer(foods, many=True)
            return Response(serializer.data)
        except Meal.DoesNotExist:
            return Response({"message": "Meal not found"}, status=status.HTTP_404_NOT_FOUND)

class NutritionOnFoodDetails(APIView):
    def get(self, request, food_id, *args, **kwargs):
        try:
            food = Food.objects.get(pk=food_id)
            nutrition = food.nutritions.all()
            serializer = NutritionSerializer(nutrition, many=True)
            return Response(serializer.data)
        except Food.DoesNotExist:
            return Response({"message": "Food not found"}, status=status.HTTP_404_NOT_FOUND)

class IngredientOnFoodDetails(APIView):
    def get(self, request, food_id, *args, **kwargs):
        try:
            food = Food.objects.get(pk=food_id)
            ingredients = food.ingredients.all()
            serializer = IngredientSerializer(ingredients, many=True)
            return Response(serializer.data)
        except Food.DoesNotExist:
            return Response({"message": "Food not found"}, status=status.HTTP_404_NOT_FOUND)

class FoodMakingStepsListView(ListAPIView):
    serializer_class = FoodMakingStepsSerializer

    def get_queryset(self):
        food_id = self.kwargs['food_id']
        return FoodMakingSteps.objects.filter(food_id=food_id).order_by('step_no')