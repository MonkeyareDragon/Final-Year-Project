from rest_framework import serializers
from fitnestx.activity.utils import calculate_calories_burned
from fitnestx.users.models import UserProfile
from fitnestx.activity.models import ActivityGoal, SensorData
from datetime import date
from django.utils import timezone

class SensorDataSerializer(serializers.ModelSerializer):
    data = serializers.ListField(child=serializers.ListField(child=serializers.FloatField()))
    date_and_time = serializers.DateTimeField(read_only=True)

    class Meta:
        model = SensorData
        fields = '__all__'
        read_only_fields = ['date_and_time', 'predicted_activity']

def calculate_age(dob):
    today = date.today()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    return age

class UserProfileSerializer(serializers.ModelSerializer):
    age = serializers.SerializerMethodField()

    class Meta:
        model = UserProfile
        fields = ('gender', 'weight', 'height', 'dob', 'age')

    def get_age(self, obj):
        dob = obj.dob
        if dob:
            return calculate_age(dob)
        return None

class SensorDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = SensorData
        fields = ('predicted_activity',)

class ActivityGoalSerializer(serializers.ModelSerializer):
    user_profile = UserProfileSerializer(source='user.userprofile', read_only=True)
    predicted_activity = serializers.SerializerMethodField()

    class Meta:
        model = ActivityGoal
        fields = ('id', 'user', 'calories_burn', 'steps', 'running_distance', 'flights_climbed', 'user_profile', 'predicted_activity')

    def get_predicted_activity(self, obj):
        user = obj.user
        current_date = timezone.now().date()
        activity_count = SensorData.objects.filter(user=user, date_and_time__date=current_date).count()
        print(activity_count)
        
        if activity_count >= 500:
            return "Sedentary"
        elif activity_count >= 750:
            return "Lightly Active"
        elif activity_count >= 1000:
            return "Moderately Active"
        elif activity_count >= 2000:
            return "Very Active"
        elif activity_count >= 5000:
            return "Extra Active"

    def create(self, validated_data):
        user = validated_data['user']
        user_profile = user.userprofile
        height = user_profile.height
        weight = user_profile.weight
        gender = user_profile.gender
        dob = user_profile.dob
        age = calculate_age(dob)
        activity_level = self.get_predicted_activity(validated_data)
        calories_burned = calculate_calories_burned(height, weight, age, gender, activity_level)
        validated_data['calories_burn'] = calories_burned
        return super().create(validated_data)