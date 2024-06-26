from django.conf import settings
from django.contrib.auth import authenticate
from django.contrib.auth.forms import SetPasswordForm
from django.contrib.auth.password_validation import validate_password
from django.contrib.auth.signals import user_logged_in
from django.contrib.auth.tokens import default_token_generator
from django.core import files
from django.utils.encoding import force_str
from django.utils.http import urlsafe_base64_decode
from django.utils.translation import gettext_lazy as _
from rest_framework import serializers
from rest_framework.exceptions import ValidationError
from rest_framework_simplejwt.tokens import RefreshToken # type: ignore
from fitnestx.core.otp import send_email_verification_code, validate_otp, send_password_reset_email
from fitnestx.users.models import User, UserProfile


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "email", "is_staff", "is_superuser"]


class UserRegisterationSerializer(serializers.ModelSerializer):
    otp_code = serializers.CharField(read_only=True)

    class Meta:
        model = User
        fields = ["otp_code", "email", "password", "first_name", "last_name"]
        extra_kwargs = {"password": {"write_only": True}}

    def validate(self, data):
        email = data["email"]
        password = data.get("password")
        mesg = "This email has been already registered."
        if User.objects.filter(email=email).exists():
            raise serializers.ValidationError({"email": mesg})
        if password:
            user = User(email=email)
            try:
                validate_password(password=password, user=user)
            except Exception as e:
                raise serializers.ValidationError({"password": e.messages})
        return data

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        request = self.context["request"]
        send_email_verification_code(request, user)
        return user


class VerirfyOtpSerializer(serializers.Serializer):
    email = serializers.EmailField(write_only=True)
    otp_code = serializers.CharField(write_only=True)

    def save(self, **kwargs):
        email = self.validated_data["email"]
        try:
            user = User.objects.get(email=email, email_verified=False)
        except User.DoesNotExist:
            raise serializers.ValidationError("User not found.")
        otp = self.validated_data["otp_code"]
        if not validate_otp(user, otp):
            raise serializers.ValidationError({"otp_code": "Invalid code."})
        user.email_verified = True
        user.save()
        refresh = self.get_token(user)
        response = {
            "user_id": user.id,
            "refresh": str(refresh),
            "access": str(refresh.access_token),
        }
        return response

    @classmethod
    def get_token(cls, user):
        return RefreshToken.for_user(user)


class ResendEmailVerificationCodeSrializer(serializers.Serializer):
    email = serializers.EmailField()

    def save(self, **kwargs):
        email = self.validated_data["email"]
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise serializers.ValidationError("Email not found.")
        else:
            request = self.context["request"]
            send_email_verification_code(request, user)
        return email


class PassWordResetSerializer(serializers.Serializer):
    """Serializer for requesting a password reset e-mail."""

    email = serializers.EmailField()

    def validate_email(self, value):
        """Validate that the email is registered."""
        try:
            user = User.objects.get(email=value)
        except User.DoesNotExist:
            raise serializers.ValidationError("User with this email does not exist.")
        return value

    def save(self):
        """Generate a one-use only link for resetting password and send it to the user."""
        email = self.validated_data["email"]
        user = User.objects.get(email=email)
        send_password_reset_email(self, user)
    
class PasswordResetConfirmSerializer(serializers.Serializer):
    new_password1 = serializers.CharField(max_length=128)
    new_password2 = serializers.CharField(max_length=128)
    uid = serializers.CharField()
    token = serializers.CharField()

    set_password_form_class = SetPasswordForm

    def validate(self, attrs):
        self._errors = {}

        # Decode the uidb64 to uid to get User object
        try:
            uid = force_str(urlsafe_base64_decode(attrs["uid"]))
            self.user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            raise ValidationError({"uid": ["Invalid value"]})

        # Construct SetPasswordForm instance
        self.set_password_form = self.set_password_form_class(
            user=self.user, data=attrs
        )
        if not self.set_password_form.is_valid():
            raise serializers.ValidationError(self.set_password_form.errors)
        if not default_token_generator.check_token(self.user, attrs["token"]):
            raise ValidationError({"token": ["Invalid value"]})

        return attrs

    def save(self):
        return self.set_password_form.save()


class TokenObtainPairSerializer(serializers.Serializer):
    email = serializers.CharField(label=_("Email/Mobile"))
    password = serializers.CharField(
        label=_("Password"),
        style={"input_type": "password"},
        trim_whitespace=False,
        write_only=True,
    )

    def validate(self, attrs):
        email = attrs.get("email")
        password = attrs.get("password")
        is_email = True if "@" in email else False

        if email and password:
            user = authenticate(
                request=self.context.get("request"), username=email, password=password
            )
            if not user:
                msg = _("Unable to log in with provided credentials.")
                raise serializers.ValidationError(msg, code="authorization")
            if is_email and not user.email_verified:
                msg = _("Email is not verified. New verification code has been sent.")
                send_email_verification_code(self.context.get("request"), user)
                raise serializers.ValidationError(
                    {"detail": msg, "email_verified": False}, code="authorization"
                )
        else:
            msg = _('Must include "email/mobile" and "password".')
            raise serializers.ValidationError(msg, code="authorization")

        refresh = self.get_token(user)
        response = {
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "is_staff": user.is_staff,
            "user_id": user.id,
            "first_name": user.first_name,
            "last_name": user.last_name,
        }
        request = self.context["request"]
        user_logged_in.send(sender=user.__class__, request=request, user=user)
        return response

    @classmethod
    def get_token(cls, user):
        return RefreshToken.for_user(user)


class PasswordChangeSerializer(serializers.Serializer):
    old_password = serializers.CharField(max_length=128)
    new_password1 = serializers.CharField(max_length=128)
    new_password2 = serializers.CharField(max_length=128)

    set_password_form_class = SetPasswordForm

    def __init__(self, *args, **kwargs):
        self.old_password_field_enabled = getattr(
            settings, "OLD_PASSWORD_FIELD_ENABLED", True
        )
        self.logout_on_password_change = getattr(
            settings, "LOGOUT_ON_PASSWORD_CHANGE", False
        )
        super().__init__(*args, **kwargs)

        # if not self.old_password_field_enabled:
        #     self.fields.pop("old_password")

        self.request = self.context.get("request")
        self.user = getattr(self.request, "user", None)

    def validate_old_password(self, value):
        invalid_password_conditions = (
            self.old_password_field_enabled,
            self.user,
            self.user.check_password(value),
        )

        if not all(invalid_password_conditions):
            err_msg = _(
                "Your old password was entered incorrectly. Please enter it again."
            )
            raise serializers.ValidationError(err_msg)
        return value

    def validate(self, attrs):
        self.set_password_form = self.set_password_form_class(
            user=self.user, data=attrs
        )

        if not self.set_password_form.is_valid():
            raise serializers.ValidationError(self.set_password_form.errors)
        return attrs

    def save(self):
        self.set_password_form.save()
        if not self.logout_on_password_change:
            from django.contrib.auth import update_session_auth_hash

            update_session_auth_hash(self.request, self.user)

class UserProfileSerializer(serializers.ModelSerializer):    
    class Meta:
        model = UserProfile
        fields = '__all__'