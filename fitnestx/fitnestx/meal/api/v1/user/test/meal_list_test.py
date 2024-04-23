import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.files.uploadedfile import SimpleUploadedFile
from fitnestx.users.models import UserProfile, User
from fitnestx.meal.models import Food, FoodIngredient, FoodMakingSteps, FoodNutrition, FoodSchedule, Ingredient, Meal, Category, Nutrition
from fitnestx.meal.serializers import CategorySerializer, DailyNutritionDataSerializer, DisplayFoodScheduleNotificationSerializer, FoodMakingStepsSerializer, FoodScheduleSerializer, FoodScheduleStatusUpdateSerializer, FoodSerializer, IngredientSerializer, MealSerializer, NutritionSerializer, UpdateFoodScheduleNotificationSerializer

@pytest.mark.django_db
def test_meal_list(api_client):
    # Create mock image files for meal_image, category_image, and food_image
    meal_file_mock = create_mock_image_file(100, 100)
    category_file_mock = create_mock_image_file(100, 100)
    food_file_mock = create_mock_image_file(100, 100)

    # Create test data with the mock image files
    meal = Meal.objects.create(
        name='Test Meal',
        food_count=2,
        meal_image=meal_file_mock
    )
    category = Category.objects.create(
        name='Test Category',
        description='Test Description',
        category_image=category_file_mock
    )
    food = Food.objects.create(
        name='Test Food',
        cooking_difficulty='Easy',
        time_required=30,
        calories=300,
        author='Test Author',
        description='Test Description',
        food_image=food_file_mock
    )
    meal.categorys.add(category)
    category.foods.add(food)
    
    # Create a user and generate a JWT token
    user = User.objects.create_user(email='kabintester@gmail.com', password='Testing@12345')
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)

    # Make a GET request to the meal-list endpoint with authentication header
    url = reverse('api_v1:meal-user:users-meal:equipment-list')
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = api_client.get(url, headers=headers)

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK

    # Check if the response data matches the serialized meal data
    serializer = MealSerializer(instance=meal)
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