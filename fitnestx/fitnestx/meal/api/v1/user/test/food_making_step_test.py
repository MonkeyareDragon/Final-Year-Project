import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.files.uploadedfile import SimpleUploadedFile
from fitnestx.users.models import User
from fitnestx.meal.models import Food, FoodMakingSteps
from fitnestx.meal.serializers import FoodMakingStepsSerializer

@pytest.mark.django_db
def test_food_making_steps_list_view(api_client):
    # Create mock image file for food_image
    food_file_mock = create_mock_image_file(200, 200)  # Food image

    # Create test data with the mock image file
    food = Food.objects.create(
        name='Test Food',
        cooking_difficulty='Easy',
        time_required=30,
        calories=300,
        author='Test Author',
        description='Test Description',
        food_image=food_file_mock
    )
    food_making_steps = FoodMakingSteps.objects.create(
        description='Test Step Description',
        step_no=1,
        food=food
    )

    # Create a user and generate a JWT token
    user = User.objects.create_user(email='kabintester@gmail.com', password='Testing@12345')
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)

    # Make a GET request to the food-making-steps-list endpoint with authentication header
    url = reverse('api_v1:meal-user:users-meal:food-making-steps-list', args=[food.id])
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = api_client.get(url, headers=headers)

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK

    # Check if the response data matches the serialized food making steps data
    serializer = FoodMakingStepsSerializer(instance=food_making_steps)
    assert response.data == [serializer.data]

def create_mock_image_file(width, height):
    file_mock = BytesIO()
    image = Image.new('RGB', (width, height))
    image.save(file_mock, 'png')
    file_mock.seek(0)
    return SimpleUploadedFile('test_image.png', file_mock.getvalue())

@pytest.fixture
def api_client():
    return APIClient()
