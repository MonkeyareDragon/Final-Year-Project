import pytest
from rest_framework.test import APIClient
from rest_framework import status
from django.urls import reverse
from PIL import Image
from io import BytesIO
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.files.uploadedfile import SimpleUploadedFile
from fitnestx.users.models import User
from fitnestx.workout.models import Exercise, ExercisePerform
from fitnestx.workout.serializers import ExercisePerformSerializer

@pytest.mark.django_db
def test_exercise_perform_details_view():
    # Create a mock image file for the exercise
    exercise_file_mock = create_mock_image_file(200, 200)

    # Create an exercise
    exercise = Exercise.objects.create(
        name='Test Exercise',
        description='Test Description',
        difficulty='Intermediate',
        calories_burn=100,
        custom_repeats=10,
        time_required='00:20:00',
        exercise_image=exercise_file_mock
    )

    # Create exercise performs related to the exercise
    exercise_perform1 = ExercisePerform.objects.create(
        header='Perform Header 1',
        description='Perform Description 1',
        step_no=1
    )
    exercise_perform1.exercises.add(exercise)

    exercise_perform2 = ExercisePerform.objects.create(
        header='Perform Header 2',
        description='Perform Description 2',
        step_no=2
    )
    exercise_perform2.exercises.add(exercise)

    # Create a user and generate a JWT token
    user = User.objects.create_user(email='kabintester@gmail.com', password='Testing@12345')
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)
    
    # Make a GET request to the workout-list endpoint with authentication header
    url = reverse('api_v1:workout-user:users-workout:exercise_perform_api',  args=[exercise.id])
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    
    # Initialize API client
    client = APIClient()
    response = client.get(url, headers=headers)

    # Check if the status code is 200 OK
    assert response.status_code == status.HTTP_200_OK

    # Check if the response data matches the serialized exercise performs
    serializer = ExercisePerformSerializer([exercise_perform1, exercise_perform2], many=True)
    assert response.data == serializer.data

def create_mock_image_file(width, height):
    file_mock = BytesIO()
    image = Image.new('RGB', (width, height))
    image.save(file_mock, 'png')
    file_mock.seek(0)
    return SimpleUploadedFile('test_image.png', file_mock.getvalue())