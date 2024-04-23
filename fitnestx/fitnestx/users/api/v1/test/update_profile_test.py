import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework_simplejwt.tokens import RefreshToken
from fitnestx.users.models import UserProfile, User

@pytest.mark.django_db
def test_user_profile_update(api_client):
    # Create a user and user profile
    user = User.objects.create_user(email='testuser@example.com', password='TestPassword123')
    profile = UserProfile.objects.create(
        user=user,
        gender='Male',
        dob='1990-01-01',
        weight='75.50',
        height='180.00',
        goal='Lose weight'
    )

    # Generate a JWT token for the user
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)

    # Prepare update data
    update_data = {
        'gender': 'Female',
        'dob': '1992-05-15',
        'weight': '70.00',
        'height': '175.00',
        'goal': 'Gain muscle',
        'user': {
            'username': 'newusername',
            'first_name': 'New',
            'last_name': 'User'
        }
    }

    # Make a PUT request to the user-profile-update endpoint
    url = reverse('api_v1:users:user_profile_update', args=[user.id])
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = api_client.put(url, data=update_data, headers=headers, format='json')

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK
    
    # Refresh the user instance from the database
    user.refresh_from_db()

    # Check if the user's username has been updated correctly
    assert user.username == update_data['user']['username']
    assert user.first_name == update_data['user']['first_name']
    assert user.last_name == update_data['user']['last_name']

    # Refresh the profile instance from the database
    profile.refresh_from_db()

    # Check if the profile data has been updated correctly
    assert profile.gender == update_data['gender']
    assert str(profile.dob) == update_data['dob']
    assert str(profile.weight) == update_data['weight']
    assert str(profile.height) == update_data['height']
    assert profile.goal == update_data['goal']

@pytest.fixture
def api_client():
    return APIClient()
