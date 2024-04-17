from django.forms import inlineformset_factory
from django.http import HttpResponse, HttpResponseNotAllowed
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from fitnestx.dashboard.utilis import get_icon_class, get_total_exercises, get_total_foods, get_total_sensor_data, get_total_users, handle_login
from fitnestx.workout.models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise, WorkoutSchedule
from fitnestx.meal.models import Category, Food, FoodIngredient, FoodMakingSteps, FoodNutrition, FoodSchedule, Ingredient, Meal, Nutrition
from fitnestx.activity.models import ActivityGoal, SensorData, SleepTracking, WaterIntake
from .forms import CategoryForm, EquipmentEditForm, EquipmentForm, ExerciseEditForm, ExerciseForm, ExercisePerformEditForm, ExercisePerformForm, FoodEditForm, FoodForm, FoodScheduleForm, UserCreateForm, UserEditForm, UserProfileEditForm, WorkoutEditForm, WorkoutExerciseEditForm, WorkoutExerciseInlineFormSet, WorkoutForm, WorkoutScheduleEditForm
from fitnestx.users.models import User, UserProfile
import csv
from django.http import JsonResponse
from django.db.models import Prefetch

def home(request):
    total_users = get_total_users()
    total_exercises = get_total_exercises()
    total_foods = get_total_foods()
    total_sensor_data = get_total_sensor_data()
    
    prev_total_users = request.session.get('prev_total_users', None)
    prev_total_exercises = request.session.get('prev_total_exercises', None)
    prev_total_foods = request.session.get('prev_total_foods', None)
    prev_total_sensor_data = request.session.get('prev_total_sensor_data', None)
    
    icon_user_class = get_icon_class(prev_total_users, total_users)
    icon_exercise_class = get_icon_class(prev_total_exercises, total_exercises)
    icon_food_class = get_icon_class(prev_total_foods, total_foods)
    icon_sensor_data_class = get_icon_class(prev_total_sensor_data, total_sensor_data)

    if request.method == "POST":
        email = request.POST.get('email')
        password = request.POST.get('password')
        handle_login(request, email, password)

    request.session['prev_total_users'] = total_users
    request.session['prev_total_exercises'] = total_exercises
    request.session['prev_total_foods'] = total_foods

    return render(request, 'dashboard/home.html', {'total_users': total_users, 'icon_user_class': icon_user_class, 'total_exercises': total_exercises, 'icon_exercise_class': icon_exercise_class, 
                                                  'total_foods': total_foods, 'icon_food_class': icon_food_class, 'total_sensor_data': total_sensor_data, 'icon_sensor_data_class': icon_sensor_data_class,'title': 'Home'})

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

def chart_user_stats(request):
    user_profiles = UserProfile.objects.all()
    heights = [profile.height for profile in user_profiles if profile.height]
    weights = [profile.weight for profile in user_profiles if profile.weight]
    genders = [profile.gender for profile in user_profiles if profile.gender]

    context = {
        'heights': heights,
        'weights': weights,
        'genders': genders,
    }
    print(context)

    return render(request, 'charts/user_stats.html', context)

def export_to_csv_food_details(request):
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="raw_food_data.csv"'

    writer = csv.writer(response)
    writer.writerow([
        'ID', 'Name', 'Cooking Difficulty', 'Time Required', 'Calories', 
        'Author', 'Description', 'Nutrition', 'Ingredient', 'Making Steps'
    ])

    # Prefetch related data to avoid multiple database queries
    foods = Food.objects.prefetch_related(
        Prefetch('foodnutrition_set', queryset=FoodNutrition.objects.select_related('nutrition').all()),
        Prefetch('foodingredient_set', queryset=FoodIngredient.objects.select_related('ingredient').all()),
        Prefetch('foodmakingsteps_set')
    ).all()

    for food in foods:
        nutrition_data = []
        for food_nutrition in food.foodnutrition_set.all():
            nutrition_data.append(f"{food_nutrition.nutrition.name}-{food_nutrition.quantity}{food_nutrition.property}")

        ingredient_data = []
        for food_ingredient in food.foodingredient_set.all():
            ingredient_data.append(f"{food_ingredient.ingredient.name} {food_ingredient.quantity_required}")

        steps_data = []
        for step in food.foodmakingsteps_set.all():
            steps_data.append(f"Step {step.step_no}: {step.description}")
        
        time_required_mins = f"{food.time_required}mins"

        calories_kcal = f"{food.calories}kcal"

        writer.writerow([
            food.id, food.name, food.cooking_difficulty, time_required_mins, calories_kcal,
            food.author, food.description,
            ', '.join(nutrition_data), 
            ', '.join(ingredient_data), 
            ', '.join(steps_data)
        ])

    return response

def export_food_schedule_to_csv(request):
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="food_schedule.csv"'

    writer = csv.writer(response)
    writer.writerow([
        'User ID', 'Food ID', 'Rating', 'Meal', 'Date', 'Time', 'Gender', 
        'DOB', 'Weight', 'Height', 'Goal', 'Calories Burn', 'Steps', 
        'Running Distance', 'Flights Climbed'
    ])

    # Fetching required data from models
    food_schedules = FoodSchedule.objects.all()

    for schedule in food_schedules:
        user_profile = UserProfile.objects.get(user=schedule.user)
        activity_goal = ActivityGoal.objects.get(user=schedule.user, date=schedule.date)
        meal_name = Meal.objects.filter(categorys__foods=schedule.food).first().name

        writer.writerow([
            schedule.user.id,
            schedule.food.id,
            schedule.rating,
            meal_name,
            schedule.date,
            schedule.time,
            user_profile.gender,
            user_profile.dob,
            user_profile.weight,
            user_profile.height,
            user_profile.goal,
            activity_goal.calories_burn,
            activity_goal.steps,
            activity_goal.running_distance,
            activity_goal.flights_climbed
        ])

    return response

def delete_user(request, user_id):
    user = get_object_or_404(User, id=user_id)
    user.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:users_user'))

def edit_user(request, user_id):
    user = get_object_or_404(User, id=user_id)
    form = UserEditForm(instance=user)

    if request.method == "POST":
        form = UserEditForm(request.POST, instance=user)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:users_user')
    else:
        form = UserEditForm(instance=user)
        return render(request, 'users/edit_user.html', {'form': form, 'title': 'Edit User Data'})
    
    return render(request, 'users/edit/edit_user.html', {'form': form, 'title': 'Edit User Data'})

def delete_user_profile(request, profile_id):
    user_profile = get_object_or_404(UserProfile, id=profile_id)
    user_profile.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:users_user_profile'))

def edit_user_profile(request, profile_id):
    user_profile = get_object_or_404(UserProfile, id=profile_id)
    form = UserProfileEditForm(instance=user_profile)

    if request.method == "POST":
        form = UserProfileEditForm(request.POST, instance=user_profile)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:users_user_profile')
    else:
        form = UserProfileEditForm(instance=user_profile)
        return render(request, 'users/edit_user_profile.html', {'form': form, 'title': 'Edit User Profile'})

    return render(request, 'users/edit/edit_user_profile.html', {'form': form, 'title': 'Edit User Profile'})

def delete_food(request, food_id):
    food = get_object_or_404(Food, id=food_id)
    food.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:meal_food'))

def edit_food(request, food_id):
    food = get_object_or_404(Food, id=food_id)
    
    if request.method == "POST":
        form = FoodEditForm(request.POST, request.FILES, instance=food)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:meal_food') 
    else:
        form = FoodEditForm(instance=food)
    
    return render(request, 'meal/edit/edit_food.html', {'form': form, 'title': 'Edit Food'})

def add_food(request):
    if request.method == 'POST':
        form = FoodForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:meal_food')
    else:
        form = FoodForm()
    
    return render(request, 'meal/add/add_food.html', {'form': form, 'title': 'Add Food'})

def add_category(request):
    if request.method == 'POST':
        form = CategoryForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:meal_category')
    else:
        form = CategoryForm()
    
    return render(request, 'meal/add/add_category.html', {'form': form, 'title': 'Add Category'})

def delete_category(request, category_id):
    category = get_object_or_404(Category, id=category_id)
    category.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:meal_category'))

def edit_category(request, category_id):
    category = get_object_or_404(Category, id=category_id)
    
    if request.method == 'POST':
        form = CategoryForm(request.POST, request.FILES, instance=category)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:meal_category')
    else:
        form = CategoryForm(instance=category)
    
    return render(request, 'meal/edit/edit_category.html', {'form': form, 'title': 'Edit Category'})

def delete_meal_schedule(request, meal_schedule_id):
    meal_schedule = get_object_or_404(FoodSchedule, id=meal_schedule_id)
    meal_schedule.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:meal_food_schedule'))

def edit_food_schedule(request, meal_schedule_id):
    schedule = get_object_or_404(FoodSchedule, id=meal_schedule_id)
    
    if request.method == 'POST':
        form = FoodScheduleForm(request.POST, instance=schedule)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:meal_food_schedule')
    else:
        form = FoodScheduleForm(instance=schedule)
    
    return render(request, 'meal/edit/edit_food_schedule.html', {'form': form, 'title': 'Edit Food Schedule'})

def add_equipment(request):
    if request.method == 'POST':
        form = EquipmentForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_equipment')
    else:
        form = EquipmentForm()
    
    return render(request, 'workout/add/add_equipment.html', {'form': form, 'title': 'Add Equipment'})

def add_exercise(request):
    if request.method == 'POST':
        form = ExerciseForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_exercise')
    else:
        form = ExerciseForm()
    
    return render(request, 'workout/add/add_exercise.html', {'form': form, 'title': 'Add Exercise'})

def add_workout(request):
    if request.method == 'POST':
        form = WorkoutForm(request.POST, request.FILES)
        WorkoutExerciseFormSet = inlineformset_factory(
            Workout, 
            WorkoutExercise, 
            form=WorkoutExerciseInlineFormSet, 
            extra=1, 
            can_delete=True
        )
        formset = WorkoutExerciseFormSet(request.POST, request.FILES, instance=Workout())
        
        if form.is_valid() and formset.is_valid():
            workout = form.save()
            formset.instance = workout
            formset.save()
            return redirect('api_v1:dashboard:workout_workout')
    else:
        form = WorkoutForm()
        WorkoutExerciseFormSet = inlineformset_factory(
            Workout, 
            WorkoutExercise, 
            form=WorkoutExerciseInlineFormSet, 
            extra=1, 
            can_delete=True
        )
        formset = WorkoutExerciseFormSet(instance=Workout())
    
    return render(request, 'workout/add/add_workout.html', {'form': form, 'formset': formset, 'title': 'Add Workout'})

def add_exercise_perform(request):
    if request.method == 'POST':
        form = ExercisePerformForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_exercise_perform')
    else:
        form = ExercisePerformForm()
    
    return render(request, 'workout/add/add_exercise_perform.html', {'form': form, 'title': 'Add Exercise Perform'})

def delete_equipment(request, equipment_id):
    equipment = get_object_or_404(Equipment, id=equipment_id)
    equipment.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:equipment_list'))

def edit_equipment(request, equipment_id):
    equipment = get_object_or_404(Equipment, id=equipment_id)
    
    if request.method == "POST":
        form = EquipmentEditForm(request.POST, request.FILES, instance=equipment)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_equipment')
    else:
        form = EquipmentEditForm(instance=equipment)
    
    return render(request, 'workout/edit/edit_equipment.html', {'form': form, 'title': 'Edit Equipment'})

def delete_exercise(request, exercise_id):
    exercise = get_object_or_404(Exercise, id=exercise_id)
    exercise.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:exercise_list'))

def edit_exercise(request, exercise_id):
    exercise = get_object_or_404(Exercise, id=exercise_id)
    
    if request.method == "POST":
        form = ExerciseEditForm(request.POST, request.FILES, instance=exercise)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_exercise')
    else:
        form = ExerciseEditForm(instance=exercise)
    
    return render(request, 'workout/edit/edit_exercise.html', {'form': form, 'title': 'Edit Exercise'})

def delete_exerciseperform(request, perform_id):
    perform = get_object_or_404(ExercisePerform, id=perform_id)
    perform.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:exerciseperform_list'))

def edit_exerciseperform(request, perform_id):
    perform = get_object_or_404(ExercisePerform, id=perform_id)
    
    if request.method == "POST":
        form = ExercisePerformEditForm(request.POST, instance=perform)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_exercise_perform') 
    else:
        form = ExercisePerformEditForm(instance=perform)
    
    return render(request, 'workout/edit/edit_exerciseperform.html', {'form': form, 'title': 'Edit ExercisePerform'})

def delete_workout(request, workout_id):
    workout = get_object_or_404(Workout, id=workout_id)
    workout.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:workout_list'))

def edit_workout(request, workout_id):
    workout = get_object_or_404(Workout, id=workout_id)
    
    if request.method == "POST":
        form = WorkoutEditForm(request.POST, request.FILES, instance=workout)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_workout') 
    else:
        form = WorkoutEditForm(instance=workout)
    
    return render(request, 'workout/edit/edit_workout.html', {'form': form, 'title': 'Edit Workout'})

def delete_workout_exercise(request, workout_exercise_id):
    workout_exercise = get_object_or_404(WorkoutExercise, id=workout_exercise_id)
    workout_exercise.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:workout_exercise_list'))

def edit_workout_exercise(request, workout_exercise_id):
    workout_exercise = get_object_or_404(WorkoutExercise, id=workout_exercise_id)
    
    if request.method == "POST":
        form = WorkoutExerciseEditForm(request.POST, instance=workout_exercise)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_workout_exercise') 
    else:
        form = WorkoutExerciseEditForm(instance=workout_exercise)
    
    return render(request, 'workout/edit/edit_workout_exercise.html', {'form': form, 'title': 'Edit Workout Exercise'})

def delete_workout_schedule(request, workout_schedule_id):
    workout_schedule = get_object_or_404(WorkoutSchedule, id=workout_schedule_id)
    workout_schedule.delete()
    return redirect(request.META.get('HTTP_REFERER', 'api_v1:dashboard:workout_schedule_list'))

def edit_workout_schedule(request, workout_schedule_id):
    workout_schedule = get_object_or_404(WorkoutSchedule, id=workout_schedule_id)
    
    if request.method == "POST":
        form = WorkoutScheduleEditForm(request.POST, instance=workout_schedule)
        if form.is_valid():
            form.save()
            return redirect('api_v1:dashboard:workout_workout_schedule') 
    else:
        form = WorkoutScheduleEditForm(instance=workout_schedule)
    
    return render(request, 'workout/edit/edit_workout_schedule.html', {'form': form, 'title': 'Edit Workout Schedule'})