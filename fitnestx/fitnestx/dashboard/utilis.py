from django.contrib.auth import authenticate, login
from django.contrib import messages
from django.shortcuts import redirect
from fitnestx.activity.models import SensorData
from fitnestx.meal.models import Food
from fitnestx.workout.models import Exercise
from fitnestx.users.models import User

def get_total_users():
    return User.objects.count()

def get_total_exercises():
    return Exercise.objects.count()

def get_total_foods():
    return Food.objects.count()

def get_total_sensor_data():
    return SensorData.objects.count()

def get_icon_class(prev_count, current_count):
    if prev_count is not None:
        if current_count > prev_count:
            return 'bx bx-trending-up icon'
        elif current_count < prev_count:
            return 'bx bx-trending-down icon down'
        else:
            return 'bx bx-equalizer icon'
    else:
        return 'bx bx-equalizer icon'

def handle_login(request, email, password):
    user = authenticate(request, email=email, password=password)
    if user is not None:
        if user.is_staff | user.is_superuser:
            login(request, user)
            username = user.username
            messages.success(request, f"Welcome, {username}!")
            return redirect('api_v1:dashboard:home')
        else:
            messages.error(request, "You are not authorized to access this page.")
            return None
    else:
        messages.error(request, "Invalid email or password! Please try again.")
        return None
