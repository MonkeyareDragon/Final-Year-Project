from django.contrib.auth.forms import UserCreationForm  # This is a built-in form that comes with Django
from fitnestx.workout.models import Equipment, Exercise, ExercisePerform, Workout, WorkoutExercise, WorkoutSchedule
from fitnestx.meal.models import Category, Food, FoodIngredient, FoodMakingSteps, FoodNutrition, FoodSchedule, Ingredient, Meal, Nutrition
from fitnestx.users.models import User, UserProfile
from django import forms

class UserCreateForm(UserCreationForm):
    email = forms.EmailField(label="", widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Email Address'}))
    first_name = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'First Name'}))
    last_name = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Last Name'}))
    
    class Meta:
        model = User
        fields = ("username", "email", "first_name", "last_name", "password1", "password2")
    
    def __init__(self, *args, **kwargs):
        super(UserCreateForm, self).__init__(*args, **kwargs)

        self.fields['username'].widget.attrs['class'] = 'form-control'
        self.fields['username'].widget.attrs['placeholder'] = 'User Name'
        self.fields['username'].label = ''
        self.fields['username'].help_text = '<span class="form-text text-muted"><small>Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.</small></span>'

        self.fields['password1'].widget.attrs['class'] = 'form-control'
        self.fields['password1'].widget.attrs['placeholder'] = 'Password'
        self.fields['password1'].label = ''
        self.fields['password1'].help_text = '<ul class="form-text text-muted small"><li>Your password can\'t be too similar to your other personal information.</li><li>Your password must contain at least 8 characters.</li><li>Your password can\'t be a commonly used password.</li><li>Your password can\'t be entirely numeric.</li></ul>'

        self.fields['password2'].widget.attrs['class'] = 'form-control'
        self.fields['password2'].widget.attrs['placeholder'] = 'Confirm Password'
        self.fields['password2'].label = ''
        self.fields['password2'].help_text = '<span class="form-text text-muted"><small>Enter the same password as before, for verification.</small></span>'	

class UserEditForm(forms.ModelForm):
    username = forms.CharField(label="", widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Username'}))
    first_name = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'First Name'}))
    last_name = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Last Name'}))
    email_verified = forms.BooleanField(label="Email Verified", required=False, widget=forms.CheckboxInput(attrs={'class':'form-check-input'}))
    is_staff = forms.BooleanField(label="Is Staff", required=False, widget=forms.CheckboxInput(attrs={'class':'form-check-input'}))
    
    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email_verified', 'is_staff']
    
    def __init__(self, *args, **kwargs):
        super(UserEditForm, self).__init__(*args, **kwargs)

        self.fields['username'].widget.attrs['class'] = 'form-control'
        self.fields['username'].widget.attrs['placeholder'] = 'Username'
        self.fields['username'].label = ''

        self.fields['first_name'].widget.attrs['class'] = 'form-control'
        self.fields['first_name'].widget.attrs['placeholder'] = 'First Name'
        self.fields['first_name'].label = ''

        self.fields['last_name'].widget.attrs['class'] = 'form-control'
        self.fields['last_name'].widget.attrs['placeholder'] = 'Last Name'
        self.fields['last_name'].label = ''

class UserProfileEditForm(forms.ModelForm):
    gender_choices = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Other', 'Other'),
    ]

    gender = forms.ChoiceField(choices=gender_choices, label="Gender", required=False, widget=forms.Select(attrs={'class':'form-control'}))
    dob = forms.DateField(label="Date of Birth", required=False, widget=forms.DateInput(attrs={'class':'form-control', 'type':'date'}))
    weight = forms.DecimalField(label="Weight (kg)", max_digits=5, decimal_places=2, required=False, widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Weight'}))
    height = forms.DecimalField(label="Height (cm)", max_digits=5, decimal_places=2, required=False, widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Height'}))
    goal_choices = [
        ('Lose Weight', 'Lose Weight'),
        ('Gain Weight', 'Gain Weight'),
        ('Maintain Weight', 'Maintain Weight'),
    ]
    goal = forms.ChoiceField(choices=goal_choices, label="Goal", required=False, widget=forms.Select(attrs={'class':'form-control'}))
    
    class Meta:
        model = UserProfile
        fields = ['gender', 'dob', 'weight', 'height', 'goal']
    
    def __init__(self, *args, **kwargs):
        super(UserProfileEditForm, self).__init__(*args, **kwargs)

        self.fields['gender'].widget.attrs['class'] = 'form-control'
        self.fields['dob'].widget.attrs['class'] = 'form-control'
        self.fields['dob'].widget.attrs['type'] = 'date'
        self.fields['weight'].widget.attrs['class'] = 'form-control'
        self.fields['height'].widget.attrs['class'] = 'form-control'
        self.fields['goal'].widget.attrs['class'] = 'form-control'

class FoodEditForm(forms.ModelForm):
    food_image = forms.ImageField(label="Food Image", required=False, widget=forms.FileInput(attrs={'class': 'form-control'}))
    name = forms.CharField(label="", max_length=50, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Food Name'}))
    cooking_difficulty = forms.CharField(label="", max_length=15, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Cooking Difficulty'}))
    time_required = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Time Required (minutes)'}))
    calories = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Calories'}))
    author = forms.CharField(label="", max_length=15, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Author'}))
    description = forms.CharField(label="", widget=forms.Textarea(attrs={'class':'form-control', 'placeholder':'Description'}))
    
    class Meta:
        model = Food
        fields = ['food_image', 'name', 'cooking_difficulty', 'time_required', 'calories', 'author', 'description']
    
    def __init__(self, *args, **kwargs):
        super(FoodEditForm, self).__init__(*args, **kwargs)

        self.fields['food_image'].widget.attrs['class'] = 'form-control-file'
        self.fields['name'].widget.attrs['class'] = 'form-control'
        self.fields['cooking_difficulty'].widget.attrs['class'] = 'form-control'
        self.fields['time_required'].widget.attrs['class'] = 'form-control'
        self.fields['calories'].widget.attrs['class'] = 'form-control'
        self.fields['author'].widget.attrs['class'] = 'form-control'
        self.fields['description'].widget.attrs['class'] = 'form-control'

class FoodForm(forms.ModelForm):
    class Meta:
        model = Food
        fields = ['food_image', 'name', 'cooking_difficulty', 'time_required', 'calories', 'author', 'description']
        widgets = {
            'food_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'cooking_difficulty': forms.TextInput(attrs={'class': 'form-control'}),
            'time_required': forms.NumberInput(attrs={'class': 'form-control'}),
            'calories': forms.NumberInput(attrs={'class': 'form-control'}),
            'author': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
        }

class FoodNutritionForm(forms.ModelForm):
    class Meta:
        model = FoodNutrition
        fields = ['nutrition', 'quantity', 'property']

class FoodIngredientForm(forms.ModelForm):
    class Meta:
        model = FoodIngredient
        fields = ['ingredient', 'quantity_required']

class CategoryForm(forms.ModelForm):
    class Meta:
        model = Category
        fields = ['category_image', 'name', 'description', 'foods']
        widgets = {
            'category_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
            'foods': forms.SelectMultiple(attrs={'class': 'form-control'}),
        }

class FoodScheduleForm(forms.ModelForm):
    class Meta:
        model = FoodSchedule
        fields = [
            'date',
            'time',
            'food',
            'user',
            'rating',
            'notification_note',
            'notify_status',
            'status',
            'check_notification',
            'send_notification',
        ]
        
        widgets = {
            'date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'time': forms.TimeInput(attrs={'class': 'form-control', 'type': 'time'}),
            'food': forms.Select(attrs={'class': 'form-control'}),
            'user': forms.Select(attrs={'class': 'form-control'}),
            'rating': forms.NumberInput(attrs={'class': 'form-control', 'min': 0, 'max': 5}),
            'notification_note': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
            'notify_status': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'status': forms.Select(attrs={'class': 'form-control'}),
            'check_notification': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'send_notification': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
        }

class EquipmentForm(forms.ModelForm):
    class Meta:
        model = Equipment
        fields = ['equipment_image', 'name', 'description']
        widgets = {
            'equipment_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
        }

class ExerciseForm(forms.ModelForm):
    class Meta:
        model = Exercise
        fields = ['exercise_image', 'name', 'description', 'difficulty', 'calories_burn', 'custom_repeats', 'time_required']
        widgets = {
            'exercise_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
            'difficulty': forms.TextInput(attrs={'class': 'form-control'}),
            'calories_burn': forms.NumberInput(attrs={'class': 'form-control'}),
            'custom_repeats': forms.NumberInput(attrs={'class': 'form-control'}),
            'time_required': forms.TextInput(attrs={'class': 'form-control'}),
        }

class WorkoutForm(forms.ModelForm):
    class Meta:
        model = Workout
        fields = ['workout_image', 'name', 'time_required', 'difficulty', 'equipments']
        widgets = {
            'workout_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'time_required': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'HH:MM:SS'}),
            'difficulty': forms.TextInput(attrs={'class': 'form-control'}),
            'equipments': forms.SelectMultiple(attrs={'class': 'form-control'}),
        }

class WorkoutExerciseInlineFormSet(forms.ModelForm):
    class Meta:
        model = WorkoutExercise
        fields = ['exercise', 'set_count']
        widgets = {
            'exercise': forms.Select(attrs={'class': 'form-control'}),
            'set_count': forms.NumberInput(attrs={'class': 'form-control'}),
        }

class ExercisePerformForm(forms.ModelForm):
    class Meta:
        model = ExercisePerform
        fields = ['header', 'description', 'step_no', 'exercises']
        widgets = {
            'header': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
            'step_no': forms.NumberInput(attrs={'class': 'form-control'}),
            'exercises': forms.SelectMultiple(attrs={'class': 'form-control'}),
        }

class EquipmentEditForm(forms.ModelForm):
    equipment_image = forms.ImageField(label="Equipment Image", required=False, widget=forms.FileInput(attrs={'class': 'form-control'}))
    name = forms.CharField(label="", max_length=50, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Equipment Name'}))
    description = forms.CharField(label="", widget=forms.Textarea(attrs={'class':'form-control', 'placeholder':'Description'}))
    
    class Meta:
        model = Equipment
        fields = ['equipment_image', 'name', 'description']
    
    def __init__(self, *args, **kwargs):
        super(EquipmentEditForm, self).__init__(*args, **kwargs)

        self.fields['equipment_image'].widget.attrs['class'] = 'form-control-file'
        self.fields['name'].widget.attrs['class'] = 'form-control'
        self.fields['description'].widget.attrs['class'] = 'form-control'
        
class ExerciseEditForm(forms.ModelForm):
    exercise_image = forms.ImageField(label="Exercise Image", required=False, widget=forms.FileInput(attrs={'class': 'form-control'}))
    name = forms.CharField(label="", max_length=50, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Exercise Name'}))
    description = forms.CharField(label="", widget=forms.Textarea(attrs={'class':'form-control', 'placeholder':'Description'}))
    difficulty = forms.CharField(label="", max_length=25, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Difficulty'}))
    calories_burn = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Calories Burn'}))
    custom_repeats = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Custom Repeats'}))
    time_required = forms.CharField(label="", max_length=25, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Time Required'}))
    
    class Meta:
        model = Exercise
        fields = ['exercise_image', 'name', 'description', 'difficulty', 'calories_burn', 'custom_repeats', 'time_required']
    
    def __init__(self, *args, **kwargs):
        super(ExerciseEditForm, self).__init__(*args, **kwargs)

        self.fields['exercise_image'].widget.attrs['class'] = 'form-control-file'
        self.fields['name'].widget.attrs['class'] = 'form-control'
        self.fields['description'].widget.attrs['class'] = 'form-control'
        self.fields['difficulty'].widget.attrs['class'] = 'form-control'
        self.fields['calories_burn'].widget.attrs['class'] = 'form-control'
        self.fields['custom_repeats'].widget.attrs['class'] = 'form-control'
        self.fields['time_required'].widget.attrs['class'] = 'form-control'

class ExercisePerformEditForm(forms.ModelForm):
    header = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Header'}))
    description = forms.CharField(label="", widget=forms.Textarea(attrs={'class':'form-control', 'placeholder':'Description'}))
    step_no = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Step No'}))
    exercises = forms.ModelMultipleChoiceField(label="", queryset=Exercise.objects.all(), widget=forms.SelectMultiple(attrs={'class':'form-control'}))

    class Meta:
        model = ExercisePerform
        fields = ['header', 'description', 'step_no', 'exercises']
    
    def __init__(self, *args, **kwargs):
        super(ExercisePerformEditForm, self).__init__(*args, **kwargs)

        self.fields['header'].widget.attrs['class'] = 'form-control'
        self.fields['description'].widget.attrs['class'] = 'form-control'
        self.fields['step_no'].widget.attrs['class'] = 'form-control'
        self.fields['exercises'].widget.attrs['class'] = 'form-control'
        
class WorkoutEditForm(forms.ModelForm):
    workout_image = forms.ImageField(label="Workout Image", required=False, widget=forms.FileInput(attrs={'class': 'form-control'}))
    name = forms.CharField(label="", max_length=100, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Workout Name'}))
    time_required = forms.DurationField(label="", widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Time Required (HH:MM:SS)'}))
    difficulty = forms.CharField(label="", max_length=20, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Difficulty'}))
    exercises = forms.ModelMultipleChoiceField(label="", queryset=Exercise.objects.all(), widget=forms.SelectMultiple(attrs={'class':'form-control'}))
    equipments = forms.ModelMultipleChoiceField(label="", queryset=Equipment.objects.all(), widget=forms.SelectMultiple(attrs={'class':'form-control'}))

    class Meta:
        model = Workout
        fields = ['workout_image', 'name', 'time_required', 'difficulty', 'exercises', 'equipments']
    
    def __init__(self, *args, **kwargs):
        super(WorkoutEditForm, self).__init__(*args, **kwargs)
        self.fields['workout_image'].widget.attrs['class'] = 'form-control-file'
        self.fields['name'].widget.attrs['class'] = 'form-control'
        self.fields['time_required'].widget.attrs['class'] = 'form-control'
        self.fields['difficulty'].widget.attrs['class'] = 'form-control'
        self.fields['exercises'].widget.attrs['class'] = 'form-control'
        self.fields['equipments'].widget.attrs['class'] = 'form-control'

class WorkoutExerciseEditForm(forms.ModelForm):
    workout = forms.ModelChoiceField(queryset=Workout.objects.all(), widget=forms.Select(attrs={'class': 'form-control'}))
    exercise = forms.ModelChoiceField(queryset=Exercise.objects.all(), widget=forms.Select(attrs={'class': 'form-control'}))
    set_count = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class': 'form-control', 'placeholder': 'Set Count'}))
    
    class Meta:
        model = WorkoutExercise
        fields = ['workout', 'exercise', 'set_count']
    
    def __init__(self, *args, **kwargs):
        super(WorkoutExerciseEditForm, self).__init__(*args, **kwargs)
        self.fields['workout'].widget.attrs['class'] = 'form-control'
        self.fields['exercise'].widget.attrs['class'] = 'form-control'
        self.fields['set_count'].widget.attrs['class'] = 'form-control'

class WorkoutScheduleEditForm(forms.ModelForm):
    date = forms.DateField(label="Date", widget=forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}))
    time = forms.TimeField(label="Time", widget=forms.TimeInput(attrs={'class': 'form-control', 'type': 'time'}))
    workout = forms.ModelChoiceField(queryset=Workout.objects.all(), widget=forms.Select(attrs={'class': 'form-control'}))
    user = forms.ModelChoiceField(queryset=User.objects.all(), widget=forms.Select(attrs={'class': 'form-control'}))
    notification_note = forms.CharField(label="Notification Note", required=False, widget=forms.Textarea(attrs={'class': 'form-control', 'rows': 3}))
    notify_status = forms.BooleanField(label="Notify Status", required=False)
    status = forms.ChoiceField(choices=WorkoutSchedule.SCHEDULE_STATUS, widget=forms.Select(attrs={'class': 'form-control'}))
    check_notification = forms.BooleanField(label="Check Notification", required=False)
    send_notification = forms.BooleanField(label="Send Notification", required=False)

    class Meta:
        model = WorkoutSchedule
        fields = ['date', 'time', 'workout', 'user', 'notification_note', 'notify_status', 'status', 'check_notification', 'send_notification']

class NutritionForm(forms.ModelForm):
    class Meta:
        model = Nutrition
        fields = ['nutrition_image', 'name']
        widgets = {
            'nutrition_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
        }

class IngredientForm(forms.ModelForm):
    class Meta:
        model = Ingredient
        fields = ['ingredient_image', 'name']
        widgets = {
            'ingredient_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
        }

class MealForm(forms.ModelForm):
    class Meta:
        model = Meal
        fields = ['meal_image', 'name', 'food_count', 'categorys']
        widgets = {
            'meal_image': forms.FileInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'food_count': forms.NumberInput(attrs={'class': 'form-control'}),
            'categorys': forms.SelectMultiple(attrs={'class': 'form-control'}),
        }

class FoodMakingStepsForm(forms.ModelForm):
    class Meta:
        model = FoodMakingSteps
        fields = ['description', 'step_no', 'food']
        widgets = {
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
            'step_no': forms.NumberInput(attrs={'class': 'form-control'}),
            'food': forms.Select(attrs={'class': 'form-control'}),
        }

class MealEditForm(forms.ModelForm):
    meal_image = forms.ImageField(label="Meal Image", required=False, widget=forms.FileInput(attrs={'class': 'form-control'}))
    name = forms.CharField(label="", max_length=25, widget=forms.TextInput(attrs={'class':'form-control', 'placeholder':'Meal Name'}))
    food_count = forms.IntegerField(label="", widget=forms.NumberInput(attrs={'class':'form-control', 'placeholder':'Food Count'}))
    categorys = forms.ModelMultipleChoiceField(queryset=Category.objects.all(), widget=forms.SelectMultiple(attrs={'class': 'form-control'}))
    
    class Meta:
        model = Meal
        fields = ['meal_image', 'name', 'food_count', 'categorys']
    
    def __init__(self, *args, **kwargs):
        super(MealEditForm, self).__init__(*args, **kwargs)

        self.fields['meal_image'].widget.attrs['class'] = 'form-control-file'
        self.fields['name'].widget.attrs['class'] = 'form-control'
        self.fields['food_count'].widget.attrs['class'] = 'form-control'
        self.fields['categorys'].widget.attrs['class'] = 'form-control'