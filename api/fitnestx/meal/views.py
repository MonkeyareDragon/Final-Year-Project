from django.http import JsonResponse
from django.views import View
from rest_framework import generics, status, viewsets
from fitnestx.users.models import User
from fitnestx.meal.models import Food, FoodMakingSteps, FoodSchedule, Meal, Nutrition
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from django.utils import timezone
from django.db.models import Sum
from django.db import models
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from datetime import datetime, timedelta
from django.db.models import Q
from fitnestx.meal.serializers import CategorySerializer, DailyNutritionDataSerializer, DisplayFoodScheduleNotificationSerializer, FoodMakingStepsSerializer, FoodScheduleSerializer, FoodScheduleStatusUpdateSerializer, FoodSerializer, IngredientSerializer, MealDetailScheduleScreenSerializer, MealSerializer, NutritionSerializer, UpdateFoodScheduleNotificationSerializer

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
        print(data)
        return data

    def update_notification(self):
        schedule_data = self.get_queryset()
        current_datetime = timezone.localtime(timezone.now())
        current_time = current_datetime.time()
        current_date = current_datetime.date()
        print(current_date, current_time)
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
                            'schedule_id': food_schedule.id,
                            'time_required': food.time_required,
                            'notify_status': food_schedule.notify_status,
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
    
class DailyNutritionDataView(APIView):
    def get(self, request, user_id, date):
        total_calorie = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_calorie=Sum('food__nutritions__quantity', filter=models.Q(food__nutritions__name='Calories')))['total_calorie'] or 0
        
        total_protein = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_protein=Sum('food__nutritions__quantity', filter=models.Q(food__nutritions__name='protein')))['total_protein'] or 0
        
        total_fat = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_fat=Sum('food__nutritions__quantity', filter=models.Q(food__nutritions__name='fat')))['total_fat'] or 0
        
        total_carbo = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_carbo=Sum('food__nutritions__quantity', filter=models.Q(food__nutritions__name='carbo')))['total_carbo'] or 0
        
        target_calorie = 1500
        target_protein = 2000  
        target_fat = 1000 
        target_carbo = 500 
        
        serializer = DailyNutritionDataSerializer(data={
            'total_calorie': total_calorie,
            'target_calorie': target_calorie,
            'total_protein': total_protein,
            'target_protein': target_protein,
            'total_fat': total_fat,
            'target_fat': target_fat,
            'total_carbo': total_carbo,
            'target_carbo': target_carbo,
        })
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data)

class FoodScheduleStatusUpdateAPIView(generics.UpdateAPIView):
    queryset = FoodSchedule.objects.all()
    serializer_class = FoodScheduleStatusUpdateSerializer
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.user == request.user:
            instance.status = 'Completed'
            instance.save()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
        else:
            return Response({'error': 'You do not have permission to change the status of this FoodSchedule.'}, status=status.HTTP_403_FORBIDDEN)

class FoodScheduleDeleteAPIView(generics.DestroyAPIView):
    queryset = FoodSchedule.objects.all()
    serializer_class = FoodScheduleSerializer
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.user == request.user:
            instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        else:
            return Response({'error': 'You do not have permission to delete this FoodSchedule.'}, status=status.HTTP_403_FORBIDDEN)

class MealUpComingBarListView(APIView):
    def get(self, request, user_id, date, time):
        try:
            datetime_str = f"{date} {time}"
            datetime_obj = datetime.strptime(datetime_str, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            return Response({"error": "Invalid date or time format. Please provide date in format 'DD/MM/YYYY' and time in format 'HH:MM:SS'."}, status=400)

        start_datetime = datetime_obj
        end_datetime = start_datetime + timedelta(days=1)
        print(start_datetime, end_datetime)

        food_schedules = FoodSchedule.objects.filter(
            Q(date__gte=start_datetime, date__lt=end_datetime) |
            Q(date=start_datetime, time__gte=start_datetime.time()) |
            Q(date=end_datetime.date(), time__lt=end_datetime.time())
        ).filter(user_id=user_id)

        data = []
        for food_schedule in food_schedules:
            food_data = {
                'name': food_schedule.food.name,
                'image': food_schedule.food.food_image.url,
                'date': food_schedule.date.strftime("%Y/%m/%d"),
                'time': food_schedule.time.strftime("%H:%M:%S"),
                'notify_status': food_schedule.send_notification,
            }
            meal_name = None
            for category in food_schedule.food.category_set.all():
                for meal in category.meal_set.all():
                    meal_name = meal.name
                    break
                if meal_name:
                    break
            meal_exists = False
            for meal in data:
                if meal['meal_name'] == meal_name:
                    meal['details'].append(food_data)
                    meal_exists = True
                    break
            if not meal_exists:
                data.append({
                    'meal_name': meal_name,
                    'details': [food_data],
                })

        return Response(data)

class WeeklyProgressView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, user_id):
        user = User.objects.get(id=user_id)
        today = timezone.now().date()
        start_date = today - timedelta(days=today.weekday()) 
        progress_data = []

        for i in range(7):
            current_date = start_date + timedelta(days=i)

            schedules = FoodSchedule.objects.filter(user=user, date=current_date)
            completed_count = schedules.filter(status='Completed').count()
            total_count = schedules.count()
            if total_count == 0:
                progress = 0
            else:
                progress = (completed_count / total_count) * 100

            progress_data.append({
                "weekly_day": current_date.strftime("%a"),
                "progress": round(progress, 2)  
            })

        return JsonResponse(progress_data, safe=False)