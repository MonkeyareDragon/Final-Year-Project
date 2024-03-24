from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from .views import (
    OTPEmailVerification,
    PasswordChangeView,
    PasswordResetConfirmView,
    PassWordResetView,
    ResendVerificaitonEmailView,
    TokenObtainPairView,
    UserProfileCreateAPIView,
    UserRegistrationView,
)

app_name = "users"

urlpatterns = [
    path("registration/", UserRegistrationView.as_view(), name="registration"),
    path("verify-otp/", OTPEmailVerification.as_view(), name="verify_email"),
    path("token/", TokenObtainPairView.as_view(), name="get_token"),
    path("refresh-token/", TokenRefreshView.as_view(), name="token_refresh"),
    path("password-reset/", PassWordResetView.as_view(), name="password_reset"),
    path('reset/<uidb64>/<token>/', PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path(
        "resend-otp/",
        ResendVerificaitonEmailView.as_view(),
        name="resend_verification_email",
    ),
    path("change-password/", PasswordChangeView.as_view(), name="change_password"),
    path("profile/", UserProfileCreateAPIView.as_view(), name='profile-create'),
]
