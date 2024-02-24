from django.shortcuts import redirect, render
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from .forms import UserCreateForm
from fitnestx.users.models import User, UserProfile
from django.urls import reverse

def home(request):
    users = User.objects.all()
    
    #Check to see if logging in
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
            messages.warning(request, "Invalid username or password! Please try again.")
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
    return render(request, 'table/user.html', {'users': users, 'title': 'User'})

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
