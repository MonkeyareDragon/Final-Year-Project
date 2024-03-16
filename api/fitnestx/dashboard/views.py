from django.shortcuts import redirect, render
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages

from fitnestx.workout.models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise, WorkoutSchedule
from fitnestx.meal.models import Category, Food, FoodMakingSteps, FoodSchedule, Ingredient, Meal, Nutrition
from fitnestx.activity.models import ActivityGoal, SensorData, SleepTracking, WaterIntake
from .forms import UserCreateForm
from fitnestx.users.models import User, UserProfile

def home(request):
    users = User.objects.all()
    
    if request.method == "POST":
        email = request.POST['email']
        password = request.POST['password']

        user = authenticate(request, email=email, password=password)

        if user is not None:
            login(request, user)
            username = user.username
            messages.success(request, f"Welcome, {username}!")
            return redirect('api_v1:dashboard:home')
        else:
            messages.error(request, "Invalid email or password! Please try again.")

    return render(request, 'dashboard/home.html', {'users': users, 'title': 'Home'})

def login_user(request):
    pass

def logout_user(request):
    logout(request)
    messages.success(request, "You have been logged out.")
    return redirect('api_v1:dashboard:home')

def register_user(request):
    if request.method == "POST":
        form = UserCreateForm(request.POST)
        if form.is_valid():
            form.save()
            email = form.cleaned_data.get('email')
            password = form.cleaned_data.get('password1')
            user = authenticate(request, email=email, password=password)
            login(request, user)
            username = user.username
            messages.success(request, f"You have Successfully Register! Welcome {username}.")
            return redirect('api_v1:dashboard:home')
    else:
        form = UserCreateForm()
        return render(request, 'authentication/register.html', {'form': form, 'title': 'Register'})
    
    return render(request, 'authentication/register.html', {'form': form, 'title': 'Register'})

def redirect_to_user(request):
    users = User.objects.all()
    
    # Redirecting to the 'table:user' URL with namespace
    return render(request, 'users/user.html', {'users': users, 'title': 'User'})

def user_record(request, pk):
    if request.user.is_authenticated:
        try:
            user_profile = UserProfile.objects.select_related('user').get(user_id=pk)
            return render(request, 'details/user_details.html', {'user_record': user_profile, 'title': 'Record'})
        except UserProfile.DoesNotExist:
            messages.warning(request, "User profile does not exist.")
            return redirect('api_v1:dashboard:table_user')
    else:   
        messages.warning(request, "You must be logged in to view that page.")
        return redirect('api_v1:dashboard:home')
    
from django.shortcuts import get_object_or_404

def delete_user_record(request, pk):
    if request.user.is_authenticated:
        try:
            user_profile = get_object_or_404(UserProfile.objects.select_related('user'), user_id=pk)
            return render(request, 'details/user_details.html', {'user_record': user_profile, 'title': 'Record'})
        except UserProfile.DoesNotExist:
            messages.error(request, "User profile does not exist.")
            return redirect('api_v1:dashboard:home')
    else:   
        messages.warning(request, "You must be logged in to view that page.")
        return redirect('api_v1:dashboard:home')


def redirect_to_user_profile(request):
    user_profile = UserProfile.objects.all()
    
    return render(request, 'users/user_profile.html', {'user_profile': user_profile, 'title': 'User Profile'})

def redirect_to_activity_goal(request):
    activity_goal = ActivityGoal.objects.all()
    
    return render(request, 'activity/activity_goal.html', {'activity_goals': activity_goal, 'title': 'User Activity Goal'})

def redirect_to_sensor_data(request):
    sensor_data = SensorData.objects.all()
    
    return render(request, 'activity/sensor_data.html', {'sensor_data': sensor_data, 'title': 'User Sensor Data'})

def redirect_to_sleep_tracking(request):
    sleep_data = SleepTracking.objects.all()
    
    return render(request, 'activity/sleep_tracking.html', {'sleep_data': sleep_data, 'title': 'User Sleep Tracking Data'})

def redirect_to_water_intake(request):
    water_intake_data = WaterIntake.objects.all()
    return render(request, 'activity/water_intake.html', {'water_intake_data': water_intake_data, 'title': 'User Water Intake Data'})

def redirect_to_nutrition(request):
    nutrition_data = Nutrition.objects.all()
    return render(request, 'meal/nutrition.html', {'nutrition_data': nutrition_data, 'title': 'Nutrition Data'})

def redirect_to_ingredient(request):
    ingredient_data = Ingredient.objects.all()
    return render(request, 'meal/ingredient.html', {'ingredient_data': ingredient_data, 'title': 'Ingredient Data'})

def redirect_to_food(request):
    food_data = Food.objects.all()
    return render(request, 'meal/food.html', {'food_data': food_data, 'title': 'Food Data'})

def redirect_to_category(request):
    category_data = Category.objects.all()
    return render(request, 'meal/category.html', {'category_data': category_data, 'title': 'Category Data'})

def redirect_to_meal(request):
    meal_data = Meal.objects.all()
    return render(request, 'meal/meal.html', {'meal_data': meal_data, 'title': 'Meal Data'})

def redirect_to_food_making_steps(request):
    steps_data = FoodMakingSteps.objects.all()
    return render(request, 'meal/food_making_steps.html', {'steps_data': steps_data, 'title': 'Food Making Steps'})

def redirect_to_food_schedule(request):
    schedules_data = FoodSchedule.objects.all()
    return render(request, 'meal/food_schedule.html', {'schedules_data': schedules_data, 'title': 'Food Schedules'})

def redirect_to_equipment(request):
    equipment_data = Equipment.objects.all()
    return render(request, 'workout/equipment.html', {'equipment_data': equipment_data, 'title': 'Equipment'})

def redirect_to_exercise(request):
    exercise_data = Exercise.objects.all()
    return render(request, 'workout/exercise.html', {'exercise_data': exercise_data, 'title': 'Exercises'})

def redirect_to_exercise_perform(request):
    perform_data = ExercisePerform.objects.all()
    return render(request, 'workout/exercise_perform.html', {'perform_data': perform_data, 'title': 'Exercise Perform'})

def redirect_to_workout(request):
    workout_data = Workout.objects.all()
    return render(request, 'workout/workout.html', {'workout_data': workout_data, 'title': 'Workouts'})

def redirect_to_workout_exercise(request):
    workout_exercise_data = WorkoutExercise.objects.all()
    return render(request, 'workout/workout_exercise.html', {'workout_exercise_data': workout_exercise_data, 'title': 'Workout Exercises'})

def redirect_to_workout_schedule(request):
    workout_schedule_data = WorkoutSchedule.objects.all()
    return render(request, 'workout/workout_schedule.html', {'workout_schedule_data': workout_schedule_data, 'title': 'Workout Schedules'})