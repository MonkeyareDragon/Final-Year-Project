from django.http import JsonResponse
from django.views import View
from rest_framework import generics, status, viewsets
from fitnestx.activity.models import ActivityGoal
from fitnestx.meal.meal_rec.rec_utilis import read_csv_data
from fitnestx.users.models import User, UserProfile
from fitnestx.meal.models import Food, FoodIngredient, FoodMakingSteps, FoodNutrition, FoodSchedule, Ingredient, Meal, Nutrition
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
import config.settings.base as settings
from sklearn.feature_extraction.text import CountVectorizer # type: ignore
from sklearn.metrics.pairwise import cosine_similarity # type: ignore
from libreco.data import DataInfo # type: ignore
from libreco.algorithms import WideDeep # type: ignore
import tensorflow as tf # type: ignore
from fitnestx.meal.serializers import CategorySerializer, DailyNutritionDataSerializer, DisplayFoodScheduleNotificationSerializer, FoodMakingStepsSerializer, FoodScheduleSerializer, FoodScheduleStatusUpdateSerializer, FoodSerializer, IngredientSerializer, MealSerializer, NutritionSerializer, UpdateFoodScheduleNotificationSerializer

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
            food_nutritions = FoodNutrition.objects.filter(food_id=food_id)
            
            details = []
            for fn in food_nutritions:
                nutrition = Nutrition.objects.get(pk=fn.nutrition_id)
                nutrition_serializer = NutritionSerializer(nutrition)
                
                detail = {
                    'id': fn.id,
                    'nutrition_image': nutrition_serializer.data['nutritionImage'],
                    'name': nutrition_serializer.data['name'],
                    'quantity': fn.quantity,
                    'property': fn.property
                }
                details.append(detail)
            
            return Response(details)
        
        except FoodNutrition.DoesNotExist:
            return Response({"message": "No nutrition details found for this food"}, status=status.HTTP_404_NOT_FOUND)

class FoodIngredientDetails(APIView):
    def get(self, request, food_id, *args, **kwargs):
        try:
            food_ingredients = FoodIngredient.objects.filter(food_id=food_id)
            
            details = []
            for fi in food_ingredients:
                ingredient = Ingredient.objects.get(pk=fi.ingredient_id)
                ingredient_serializer = IngredientSerializer(ingredient)
                
                detail = {
                    'id': fi.id,
                    'ingredient_image': ingredient_serializer.data['ingredient_image'],
                    'name': ingredient_serializer.data['name'],
                    'quantity_required': fi.quantity_required
                }
                details.append(detail)
            
            return Response(details)
        
        except FoodIngredient.DoesNotExist:
            return Response({"message": "No ingredient details found for this food"}, status=status.HTTP_404_NOT_FOUND)

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
        total_cholesterol = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_cholesterol=Sum('food__foodnutrition__quantity', filter=models.Q(food__foodnutrition__nutrition__name='Cholesterol')))['total_cholesterol'] or 0
        
        total_vitaminc = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_vitaminc=Sum('food__foodnutrition__quantity', filter=models.Q(food__foodnutrition__nutrition__name='Vitamin C')))['total_vitaminc'] or 0
        
        total_fat = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_fat=Sum('food__foodnutrition__quantity', filter=models.Q(food__foodnutrition__nutrition__name='Fat')))['total_fat'] or 0
        
        total_carbo = FoodSchedule.objects.filter(
            user=user_id,
            date=date,
            status='Completed'
        ).aggregate(total_carbo=Sum('food__foodnutrition__quantity', filter=models.Q(food__foodnutrition__nutrition__name='Carbohydrate')))['total_carbo'] or 0
        
        target_cholesterol = 1500
        target_vitaminc = 2000  
        target_fat = 1000 
        target_carbo = 500 
        
        serializer = DailyNutritionDataSerializer(data={
            'total_cholesterol': total_cholesterol,
            'target_cholesterol': target_cholesterol,
            'total_vitaminc': total_vitaminc,
            'target_vitaminc': target_vitaminc,
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

class UserNotificationScheduleView(View):
    def get(self, request, user_id):
        user_schedules = FoodSchedule.objects.filter(user_id=user_id, notify_status=False)
        schedules_data = []
        for schedule in user_schedules:
            schedule_data = {
                'id': schedule.id,
                'date': schedule.date,
                'time': schedule.time,
                'food': schedule.food.name,
                'notification_note': schedule.notification_note,
                'status': schedule.status,
                'check_notification': schedule.check_notification,
                'send_notification': schedule.send_notification
            }
            schedules_data.append(schedule_data)
        return JsonResponse({'schedules': schedules_data})

class UpdateNotificationAPI(APIView):
    def put(self, request, schedule_id):
        try:
            schedule = FoodSchedule.objects.get(id=schedule_id)
            notification_message = request.data.get('notification_note')
            notify_status = request.data.get('notify_status')

            schedule.notification_note = notification_message
            schedule.notify_status = notify_status
            schedule.save()

            return Response({'message': 'Notification status updated successfully'}, status=status.HTTP_200_OK)
        except FoodSchedule.DoesNotExist:
            return Response({'message': 'Schedule not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'message': f'Failed to update notification status: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class SimilarFoodRecommendationView(View):

    @staticmethod
    def recommend(food, final_df, similarity):
        index = final_df[final_df['ID'] == food].index[0]
        distances = sorted(list(enumerate(similarity[index])), reverse=True, key=lambda x: x[1])
        recommended_food_names = [final_df.iloc[i[0]].ID for i in distances[1:5]]
        return recommended_food_names

    @staticmethod
    def rec_process():
        formatted_file_path = settings.FORMATED_DATA_FILEPATH
        final_df = read_csv_data(formatted_file_path)

        cv = CountVectorizer(max_features=5000, stop_words='english')
        vector = cv.fit_transform(final_df['tags']).toarray()
        similarity = cosine_similarity(vector)
        return similarity, final_df

    def get(self, request, food_id, *args, **kwargs):
        try:
            similarity, final_df = self.rec_process()
            recommended_food_ids = self.recommend(food_id, final_df, similarity)

            recommended_foods = Food.objects.filter(id__in=recommended_food_ids).values(
                'name', 'cooking_difficulty', 'time_required', 'calories', 'food_image'
            )

            media_url = settings.MEDIA_URL
            transformed_recommended_foods = []
            for food in recommended_foods:
                transformed_food = {
                    "name": food['name'],
                    "cooking_difficulty": food['cooking_difficulty'],
                    "time_required": food['time_required'],
                    "calories": food['calories'],
                    "food_image": f"{media_url}{food['food_image']}"
                }
                transformed_recommended_foods.append(transformed_food)

            return JsonResponse(transformed_recommended_foods, safe=False)

        except Food.DoesNotExist:
            return JsonResponse({'error': 'Food not found'}, status=404)

class MealRecBasedOnUserActivity(View):
    
    _loaded_model = None
    
    @classmethod
    def load_model(cls, path):
        if cls._loaded_model is not None:
            return cls._loaded_model
        
        try:
            tf.compat.v1.reset_default_graph()
            loaded_data_info = DataInfo.load(path, model_name="meal_rec_deep")
            cls._loaded_model = WideDeep.load(path, model_name="meal_rec_deep", data_info=loaded_data_info, manual=True)
            return cls._loaded_model
        except Exception as e:
            raise Exception(f"Failed to load model: {str(e)}")
    
    def get_user_data(self, user_id, date):
        try:
            user = User.objects.get(id=user_id)
            profile = UserProfile.objects.get(user=user)
            
            try:
                activity_goal = ActivityGoal.objects.filter(user=user, date=date).latest('date')
            except ActivityGoal.DoesNotExist:
                activity_goal = None

            user_feats = {
                "Gender": profile.gender,
                "Goal": profile.goal,
                "Height": float(profile.height) if profile.height else 0,
                "Weight": float(profile.weight) if profile.weight else 0,
                "Calories Burn": activity_goal.calories_burn if activity_goal and activity_goal.calories_burn else 0,
                "Steps": activity_goal.steps if activity_goal and activity_goal.steps else 0,
                "Running Distance": float(activity_goal.running_distance) if activity_goal and activity_goal.running_distance else 0,
                "Flights Climbed": activity_goal.flights_climbed if activity_goal and activity_goal.flights_climbed else 0
            }

            return user_feats

        except Exception as e:
            raise Exception(f"Failed to fetch user data: {str(e)}")
    
    @staticmethod
    def get_recommendation(user_id, number_of_recommendations, user_feats):
        try:
            model_path = settings.LIBRECOMMENDER_MODEL_FILEPATH
            model = MealRecBasedOnUserActivity.load_model(model_path)

            recommendations = model.recommend_user(user=user_id, n_rec=number_of_recommendations, user_feats=user_feats)
            food_details_list = []
            
            for food_id in recommendations[user_id]:
                try:
                    food = Food.objects.get(id=food_id)
                    food_details = {
                        "name": food.name,
                        "cooking_difficulty": food.cooking_difficulty,
                        "time_required": food.time_required,
                        "calories": food.calories,
                        "food_image": food.food_image.url if food.food_image else None
                    }
                    food_details_list.append(food_details)
                except Food.DoesNotExist:
                    continue
        except Exception as e:
            raise Exception(f"Failed to get recommendations: {str(e)}")
        return food_details_list   
        
    def get(self, request, user_id, date, *args, **kwargs):
        try:
            number_of_recommendations = 5
            user_feats = self.get_user_data(user_id, date)
            recommendations = self.get_recommendation(user_id, number_of_recommendations, user_feats)
            
            return JsonResponse(recommendations, safe=False)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)