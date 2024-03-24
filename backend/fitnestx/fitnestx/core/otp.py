import base64

from django.conf import settings
from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMultiAlternatives
from django.template import loader
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from pyotp import TOTP
from django.contrib.auth.forms import PasswordResetForm
from django.contrib.auth.tokens import default_token_generator
from django.template.loader import render_to_string
from django.core.mail import send_mail
from django.urls import reverse

OTP_VALIDITY_TIME: int = 60 * 15


def get_base32_key(user) -> str:
    # Generates a base32 value based on the key provided.
    # Key used should be hashed value of password.
    key = settings.SECRET_KEY + str(user.pk)
    key = bytes(key, encoding="UTF-8")
    val = base64.b32encode(key)
    val = str(val)
    return val.split("'")[1]


def generate_otp(user, digits=6) -> int:
    base32_key = get_base32_key(user)
    otp = TOTP(base32_key, interval=OTP_VALIDITY_TIME, digits=digits).now()
    return otp


def validate_otp(user, otp: int, digits=6) -> bool:
    base32_key = get_base32_key(user)
    return TOTP(base32_key, interval=OTP_VALIDITY_TIME, digits=digits).verify(otp)


def send_email_verification_code(request, user):
    otp_code = generate_otp(user)
    subject = f"Email Verification Code: {otp_code}"
    from_email = settings.DEFAULT_FROM_EMAIL
    to = [user.email]
    email_template_name = "email_templates/registration_code.txt"
    html_email_template_name = "email_templates/registration_code.html"
    current_site = get_current_site(request)
    site_name = current_site.name
    context = {"otp": otp_code, "site_name": site_name}
    text_content = loader.render_to_string(email_template_name, context)
    html_content = loader.render_to_string(html_email_template_name, context)
    email = EmailMultiAlternatives(subject, text_content, from_email, to)
    email.attach_alternative(html_content, "text/html")
    email.send()

def send_password_reset_email(self, user):
    """Generate a password reset link and send an email to the user."""
    request = self.context.get('request')
    token = default_token_generator.make_token(user)
    uid = urlsafe_base64_encode(force_bytes(user.pk))
    reset_password_link = request.build_absolute_uri(
        reverse('api_v1:users:password_reset_confirm', kwargs={'uidb64': uid, 'token': token}))
    
    subject = f"Password change link: {reset_password_link}"
    to = [user.email]
    from_email = settings.DEFAULT_FROM_EMAIL
    email_template_name = "password_change_templates/password_reset_email.txt"
    html_email_template_name = "password_change_templates/password_reset_email.html"
    current_site = get_current_site(request)
    site_name = current_site.name
    context = {"link": reset_password_link,
               "domain": "http://127.0.0.1:8000",
               "site_name": site_name, 
               "uid": uid,
               "token": token,
               "user": user
               }
    text_content = loader.render_to_string(email_template_name, context)
    html_content = loader.render_to_string(html_email_template_name, context)
    email = EmailMultiAlternatives(subject, text_content, from_email, to)
    email.attach_alternative(html_content, "text/html")
    email.send()