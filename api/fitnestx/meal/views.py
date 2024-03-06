from rest_framework import generics, status, viewsets
from fitnestx.meal.models import Food, FoodMakingSteps, FoodSchedule, Meal
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from django.utils import timezone
from fitnestx.meal.serializers import CategorySerializer, DisplayFoodScheduleNotificationSerializer, FoodMakingStepsSerializer, FoodScheduleSerializer, FoodSerializer, IngredientSerializer, MealDetailScheduleScreenSerializer, MealSerializer, NutritionSerializer, UpdateFoodScheduleNotificationSerializer

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

class FoodScheduleCreateAPIView(generics.CreateAPIView):
    queryset = FoodSchedule.objects.all()
    serializer_class = FoodScheduleSerializer

class UpdateFoodScheduleNotificationView(viewsets.ModelViewSet):
    serializer_class = UpdateFoodScheduleNotificationSerializer
    
    def get_queryset(self):
        data = FoodSchedule.objects.filter(notify_status__lte=False)
        return data

    def update_notification(self):
        schedule_data = self.get_queryset()
        current_datetime = timezone.localtime(timezone.now())
        current_time = current_datetime.time()
        current_date = current_datetime.date()
        
        try:
            for schedule in schedule_data:
                if schedule.date <= current_date and schedule.time <= current_time:
                    schedule.notification_note = f"Hello {schedule.user.username}, it's time for your scheduled meal: {schedule.food.name}."
                    schedule.notify_status = True
                    schedule.save()
                else:
                    return Response({"message": "No notification to update"})
        except schedule_data.DoesNotExist:
            return Response({"message": "No notification data is found"})
    
    def list(self, request, *args, **kwargs):
        self.update_notification()
        return super().list(request, *args, **kwargs)

class DisplayFoodScheduleNotificationView(generics.ListAPIView):
    serializer_class = DisplayFoodScheduleNotificationSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return FoodSchedule.objects.filter(user_id=user_id, notify_status=True)

class MealScheduleScreenDetailView(APIView):
    def get(self, request, user_id, date):
        meals = Meal.objects.all()
        data = []
        for meal in meals:
            details = []
            total_calories = 0 
            for category in meal.categorys.all():
                for food in category.foods.all():
                    food_schedules = food.foodschedule_set.filter(user_id=user_id, date=date)
                    for food_schedule in food_schedules:
                        food_data = {
                            'name': food.name,
                            'time': food_schedule.time,
                            'image': food.food_image.url,
                            'status': food_schedule.status,
                            'schedule_id': food_schedule.id
                        }
                        details.append(food_data)
                        total_calories += food.calories
            meal_data = {
                'meal_name': meal.name,
                'total_calories': total_calories,
                'details': details
            }
            data.append(meal_data)
        return Response(data)