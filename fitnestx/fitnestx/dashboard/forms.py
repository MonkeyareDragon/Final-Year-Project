from django.contrib.auth.forms import UserCreationForm  # This is a built-in form that comes with Django
from fitnestx.meal.models import Category, Food, FoodSchedule
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