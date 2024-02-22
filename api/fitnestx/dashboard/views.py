from django.shortcuts import redirect, render
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from .forms import UserCreateForm
from fitnestx.users.models import User

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
        return render(request, 'dashboard/register.html', {'form': form, 'title': 'Register'})
    
    return render(request, 'dashboard/register.html', {'form': form, 'title': 'Register'})