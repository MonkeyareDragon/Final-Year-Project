from datetime import datetime
import os
from PIL import Image
from rest_framework import serializers
from django.utils import timezone
from config.settings import base as settings
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

class DisplayFoodScheduleNotificationSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()
    time = serializers.SerializerMethodField()
    send_datetime = serializers.SerializerMethodField()
    check_notification = serializers.BooleanField(default=True)
    
    class Meta:
        model = FoodSchedule
        fields = ('image', 'notification_note', 'time', 'check_notification', 'send_datetime')
    
    def resize_image(self, image_url):
        image_rel_path = image_url.split('media/')[-1]
        image_path = os.path.join(settings.MEDIA_ROOT, image_rel_path)

        image = Image.open(image_path)
        image_resized = image.resize((100, 100))
        image_name, image_extension = os.path.splitext(image_url)
        resized_image_name = f"{image_name}_notification{image_extension}"
        
        image_resize_path = resized_image_name.split('media/')[-1]
        resized_image_path = os.path.join(settings.MEDIA_ROOT, image_resize_path)
        image_resized.save(resized_image_path)
        
        return resized_image_name

    def get_image(self, obj):
        resized_image_path = self.resize_image(obj.food.food_image.url)
        return resized_image_path

    def get_time(self, obj):
        current_datetime = timezone.localtime(timezone.now())
        schedule_datetime = timezone.make_aware(datetime.combine(obj.date, obj.time))
        # Calculate time difference
        delta = current_datetime - schedule_datetime
        if delta.days == 0:
            minutes = delta.seconds // 60
            if minutes < 60:
                if minutes < 1:
                    return 'Less than a minute ago'
                else:
                    return f'About {minutes} minutes ago'
            else:
                hours = minutes // 60
                return f'About {hours} hours ago'
        elif delta.days == 1:
            return obj.date.strftime('%Y-%m-%d')
        else:
            return obj.date.strftime('%Y-%m-%d')
    
    def get_send_datetime(self, obj):
        return obj.date.strftime('%Y-%m-%d') + ' ' + obj.time.strftime('%H:%M:%S')