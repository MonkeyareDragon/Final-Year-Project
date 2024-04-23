import datetime
from decimal import Decimal
from django.conf import settings
from fitnestx.users.api.v1.serializers import UserProfileSerializer
import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from rest_framework_simplejwt.tokens import RefreshToken
from fitnestx.users.models import User, UserProfile

@pytest.mark.django_db
def test_user_profile_view(api_client):

    # Create a user and user profile
    user = User.objects.create_user(email='testuser@example.com', password='TestPassword123')
    profile = UserProfile.objects.create(
        user=user,
        gender='Male',
        dob='1990-01-01',
        weight='75.50',
        height='180.00',
        goal='Lose weight',
        avatar= 'default.png'
    )

    # Generate a JWT token for the user
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)

    # Make a GET request to the user-profile endpoint with the user ID
    url = reverse('api_v1:users:user-profile', args=[user.id])
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = api_client.get(url, headers=headers)

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK

    # Check if the response data matches the serialized user profile data
    serializer = UserProfileSerializer(instance=profile)
    expected_data = {'avatar': 'default.png', 'gender': 'Male', 'dob': datetime.date(1990, 1, 1), 'weight': Decimal('75.50'), 'height': Decimal('180.00'), 'goal': 'Lose weight', 'user': {'username': '', 'first_name': '', 'last_name': ''}}
    assert response.data == expected_data

@pytest.fixture
def api_client():
    return APIClient()
