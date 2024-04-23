from fitnestx.users.api.v1.serializers import UserProfileSerializer
import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from fitnestx.users.models import User, UserProfile

@pytest.mark.django_db
def test_user_profile_create(api_client):

    # Create a user
    user = User.objects.create_user(email='testuser@example.com', password='TestPassword123')

    # Define user profile data
    profile_data = {
        "user": user.id,
        "gender": "Male",
        "dob": "1990-01-01",
        "weight": "75.50",
        "height": "180.00",
        "goal": "Lose weight",
        "avatar": "test.png"
    }

    # Make a POST request to the profile-create endpoint
    url = reverse('api_v1:users:profile-create')
    response = api_client.post(url, data=profile_data, format='json')

    # Check if the status code is 201 CREATED
    assert response.status_code == status.HTTP_201_CREATED

    # Check if the response data matches the serialized profile data
    serializer = UserProfileSerializer(instance=UserProfile.objects.get(user=user))
    assert response.data == serializer.data

@pytest.fixture
def api_client():
    return APIClient()
