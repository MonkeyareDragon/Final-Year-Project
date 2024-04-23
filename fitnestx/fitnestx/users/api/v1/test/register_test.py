import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from fitnestx.users.models import User
from fitnestx.users.api.v1.serializers import UserRegisterationSerializer

@pytest.mark.django_db
def test_user_registration(api_client):
    # Define registration data
    registration_data = {
        "email": "testuser@example.com",
        "password": "TestPassword123",
        "first_name": "Test",
        "last_name": "User"
    }

    # Make a POST request to the registration endpoint
    url = reverse('api_v1:users:registration')
    response = api_client.post(url, data=registration_data)

    # Check if the status code is 201 CREATED
    assert response.status_code == status.HTTP_201_CREATED

    # Check if the response data matches the serialized registration data
    serializer = UserRegisterationSerializer(instance=User.objects.get(email=registration_data["email"]))
    assert response.data == {"detail": "Verification email sent."}

@pytest.fixture
def api_client():
    return APIClient()
