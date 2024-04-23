import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from PIL import Image
from io import BytesIO
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.files.uploadedfile import SimpleUploadedFile
from fitnestx.users.models import UserProfile, User
from fitnestx.meal.models import Food, Ingredient, FoodIngredient
from fitnestx.meal.serializers import IngredientSerializer

@pytest.mark.django_db
def test_ingredient_list_filtered(api_client):
    # Create mock image files for food_image and ingredient_image
    food_file_mock = create_mock_image_file(200, 200)  # Food image
    ingredient_file_mock = create_mock_image_file(100, 100)  # Ingredient image

    # Create test data with the mock image files
    food = Food.objects.create(
        name='Test Food',
        cooking_difficulty='Easy',
        time_required=30,
        calories=300,
        author='Test Author',
        description='Test Description',
        food_image=food_file_mock
    )
    ingredient = Ingredient.objects.create(
        name='Test Ingredient',
        ingredient_image=ingredient_file_mock
    )
    food_ingredient = FoodIngredient.objects.create(
        food=food,
        ingredient=ingredient,
        quantity_required='Test Quantity'
    )

    # Create a user and generate a JWT token
    user = User.objects.create_user(email='kabintester@gmail.com', password='Testing@12345')
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)

    # Make a GET request to the Ingredient-list-filtered endpoint with authentication header
    url = reverse('api_v1:meal-user:users-meal:Ingredient-list-filtered', args=[food.id])
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = api_client.get(url, headers=headers)

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK

    # Check if the response data matches the serialized ingredient data
    ingredient_serializer = IngredientSerializer(instance=ingredient)
    expected_data = [{
        'id': food_ingredient.id,
        'ingredient_image': ingredient_serializer.data['ingredient_image'],
        'name': ingredient_serializer.data['name'],
        'quantity_required': food_ingredient.quantity_required
    }]
    assert response.data == expected_data

def create_mock_image_file(width, height):
    file_mock = BytesIO()
    image = Image.new('RGB', (width, height))
    image.save(file_mock, 'png')
    file_mock.seek(0)
    return SimpleUploadedFile('test_image.png', file_mock.getvalue())

@pytest.fixture
def api_client():
    return APIClient()
