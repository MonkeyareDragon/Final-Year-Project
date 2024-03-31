from django.utils.decorators import method_decorator
from django.utils.translation import gettext_lazy as _
from django.views.decorators.debug import sensitive_post_parameters
from fitnestx.users.models import UserProfile
from drf_spectacular.utils import extend_schema
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.generics import (
    CreateAPIView,
    GenericAPIView,
    RetrieveAPIView,
    UpdateAPIView,
)
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from fitnestx.core.mixins import CustomPageNumberPagination

from .serializers import (
    PasswordChangeSerializer,
    PasswordResetConfirmSerializer,
    PassWordResetSerializer,
    ResendEmailVerificationCodeSrializer,
    TokenObtainPairSerializer,
    UserProfileSerializer,
    UserRegisterationSerializer,
    UserSerializer,
    VerirfyOtpSerializer,
)

# from rest_framework.throttling import ScopedRateThrottle

sensitive_post_parameters_m = method_decorator(
    sensitive_post_parameters(
        "password", "old_password", "new_password1", "new_password2"
    )
)


class UserRegistrationView(CreateAPIView):
    """
    Creates user with given email and send 4 digit verification code.
    """

    serializer_class = UserRegisterationSerializer
    permission_classes = ()

    @sensitive_post_parameters_m
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        headers = self.get_success_headers(serializer.data)
        return Response(
            {"detail": _("Verification email sent.")},
            status=status.HTTP_201_CREATED,
            headers=headers,
        )


class OTPEmailVerification(APIView):
    serializer_class = VerirfyOtpSerializer
    permission_classes = ()

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        data = serializer.save()
        return Response(
            {"detail": "Email verified.", **data}, status=status.HTTP_200_OK
        )


class PassWordResetView(APIView):
    """
    Sends password reset link if the registered email is provided.

    POST params: email
    :returns success/failure message
    """

    permission_classes = ()

    def get_serializer(self, *args, **kwargs):
        return PassWordResetSerializer(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({"detail": "Password reset link sent."}, status=status.HTTP_200_OK)


class PasswordResetConfirmView(GenericAPIView):
    """
    Password reset e-mail link is confirmed, therefore
    this resets the user's password.

    Accepts the following POST parameters: token, uid, new_password1, new_password2
    Returns the success/fail message.
    """

    serializer_class = PasswordResetConfirmSerializer
    permission_classes = ()

    @sensitive_post_parameters_m
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({"detail": _("Password has been reset with the new password.")})


class TokenObtainPairView(APIView):
    """
    Takes a set of user credentials and returns an access and refresh JSON web
    token pair to prove the authentication of those credentials and email_verified status.
    """

    serializer_class = TokenObtainPairSerializer
    permission_classes = ()

    @sensitive_post_parameters_m
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    @extend_schema(request=TokenObtainPairSerializer)
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        return Response(serializer.validated_data, status=status.HTTP_200_OK)


class ResendVerificaitonEmailView(APIView):
    permission_classes = ()
    serializer_class = ResendEmailVerificationCodeSrializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({"detail": "Verificaiton email sent."}, status=status.HTTP_200_OK)


class PasswordChangeView(GenericAPIView):
    """
    Calls Django Auth SetPasswordForm save method.
    Accepts the following POST parameters: new_password1, new_password2
    Returns the success/fail message.
    """

    serializer_class = PasswordChangeSerializer
    permission_classes = (IsAuthenticated,)

    @sensitive_post_parameters_m
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({"detail": _("New password has been saved.")})

class UserProfileCreateAPIView(CreateAPIView):
    """
    Creates user profile with details like gender, DOB, height, weight and goal.
    """
    permission_classes = ()
    
    def post(self, request):
        # Ensure user ID is provided in the request data
        user_id = request.data.get('user')
        if user_id:
            # Assign the provided user ID to the user profile
            request.data['user'] = user_id
            
            serializer = UserProfileSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "User ID is missing in the request data."}, status=status.HTTP_400_BAD_REQUEST)
                
class UserProfileView(RetrieveAPIView):
    """
    Retrieve the user profile of a given user_id.
    """
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = (IsAuthenticated,)
    lookup_field = 'user_id'

    def retrieve(self, request, *args, **kwargs):
        user_id = self.kwargs.get('user_id')
        try:
            user_profile = UserProfile.objects.get(user_id=user_id)
            user_data = {
                'avatar': user_profile.avatar,
                'gender': user_profile.gender,
                'dob': user_profile.dob,
                'weight': user_profile.weight,
                'height': user_profile.height,
                'goal': user_profile.goal,
                'user': {
                    'username': user_profile.user.username,
                    'first_name': user_profile.user.first_name,
                    'last_name': user_profile.user.last_name
                }
            }
            return Response(user_data, status=status.HTTP_200_OK)
        except UserProfile.DoesNotExist:
            return Response({'error': 'User profile not found'}, status=status.HTTP_404_NOT_FOUND)

class UserProfileUpdateView(UpdateAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'user_id'

    def update(self, request, *args, **kwargs):
        user_id = self.kwargs.get('user_id')
        try:
            user_profile = UserProfile.objects.get(user_id=user_id)
            user_data = request.data.pop('user', None)
            
            if user_data:
                user_instance = user_profile.user
                user_instance.username = user_data.get('username', user_instance.username)
                user_instance.first_name = user_data.get('first_name', user_instance.first_name)
                user_instance.last_name = user_data.get('last_name', user_instance.last_name)
                user_instance.save()

            serializer = self.get_serializer(user_profile, data=request.data, partial=True)
            
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
        except UserProfile.DoesNotExist:
            return Response({'error': 'User profile not found'}, status=status.HTTP_404_NOT_FOUND)