from django.contrib.auth.models import AbstractUser
from django.db.models import BooleanField, CharField, EmailField
from django.utils.translation import gettext_lazy as _
from django.db import models
import config.settings.base as settings

from .managers import CustomUserManager

class User(AbstractUser):
    """Default user for FitnestX."""

    SOCIAL_AUTH_PROVIDERS = (
        ("GOOGLE", ("GOOGLE")),
        ("FACEBOOK", ("FACEBOOK")),
    )
    USER_TYPE = (("USER", "USER"),("PRO-USER", "PRO-USER"))

    name = CharField(_("Name of User"), blank=True, max_length=255)
    email = EmailField(_("Email Address"), unique=True)
    email_verified = BooleanField(default=False)
    social_auth = CharField(
        choices=SOCIAL_AUTH_PROVIDERS,
        max_length=100,
        blank=True,
        null=True,
        help_text="This field indicates through which social app has user logged in or signup",
    )
    user_type = CharField(max_length=15, choices=USER_TYPE, default="USER")
    first_name = None  # type: ignore
    last_name = None  # type: ignore
    username = None  # type: ignore

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return self.name or self.email or self.mobile or ""

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    avatar = models.TextField(default=f'{settings.AVATAR_URI_PREFIX}/default.png')
    
    gender = models.CharField(max_length=10, null=True)
    dob = models.DateField(null=True)
    weight = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    height = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    goal = models.CharField(max_length=15, null=True)
    
    class Meta:
        db_table = 'user_profile'