from django.urls import path
from . import views

app_name = "dashboard"

urlpatterns = [
    path("", views.home, name="home"),
    path("login/", views.login_user, name="login"),
    path("logout/", views.logout_user, name="logout"),
    path("register/", views.register_user, name="register"),
    path('table/user/', views.redirect_to_user, name='table_user'),
    path('details/user/<int:pk>/', views.user_record, name='details'),
    path('delete_details/user/<int:pk>/', views.delete_user_record, name='delete_details'),
]
