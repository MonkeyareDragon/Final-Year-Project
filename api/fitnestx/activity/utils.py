#import numpy as np
#import tensorflow as tf
from datetime import date, datetime
from fitnestx.activity.models import SensorData
import config.settings.base as settings

#model = tf.keras.models.load_model(settings.MODEL_FILEPATH)

# def predict_sensor_data(sensor_data):
#     data = np.array(sensor_data['data'])  # Convert to NumPy array
#     data = np.expand_dims(data, axis=0)   # Add batch dimension

#     # Make predictions
#     predictions = model.predict(data)

#     class_labels = {0: 'Walking', 1: 'Jogging', 2: 'Stairs', 3: 'Sitting', 4: 'Standing'}

#     predicted_class_index = np.argmax(predictions)
#     predicted_class_label = class_labels[predicted_class_index]

#     # Set the predicted activity and current date and time
#     sensor_data['predicted_activity'] = predicted_class_label
#     sensor_data['date_and_time'] = datetime.now()

#     return sensor_data


def get_age_years(dob):
    """
    Calculate age in years based on the date of birth.
    
    Args:
        dob (date): Date of birth of the user.
        
    Returns:
        int: Age in years.
    """
    today = date.today()
    age_years = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    return age_years


def get_activity_level(user):
    """
    Get the activity level status based on the user's SensorData activity table for the current day.
    
    Args:
        user (User): User object for whom the activity level is to be determined.
        
    Returns:
        str: Activity level status ("sedentary", "lightly active", "moderately active", "very active", "extra active").
            Returns None if no activity data is available for the current day.
    """
    today = date.today()
    sensor_data = SensorData.objects.filter(user=user, date_and_time__date=today)

    if not sensor_data:
        return "sedentary"  # No activity data available for the current day

    total_activity = sum([data['activity_level'] for data in sensor_data])

    if total_activity < 100:
        return "sedentary"
    elif total_activity < 500:
        return "lightly active"
    elif total_activity < 1000:
        return "moderately active"
    elif total_activity < 1500:
        return "very active"
    else:
        return "extra active"


def calculate_calories_burned(height_cm, weight_kg, age_years, gender, activity_level):
    # Constants for calculating Basal Metabolic Rate (BMR)
    if activity_level.lower() == "sedentary":
        activity_factor = 1.2
    elif activity_level.lower() == "lightly active":
        activity_factor = 1.375
    elif activity_level.lower() == "moderately active":
        activity_factor = 1.55
    elif activity_level.lower() == "very active":
        activity_factor = 1.725
    elif activity_level.lower() == "extra active":
        activity_factor = 1.9
    else:
        raise ValueError("Invalid activity level. Please choose from: Sedentary, Lightly active, Moderately active, Very active, Extra active")

    height_m = height_cm/100  # Convert height from cm to m
    
    # Calculate Basal Metabolic Rate (BMR) using Harris-Benedict equation
    # Source: 
    if gender.lower() == "male":
        bmr = 260 + (9.65 * weight_kg) + (573 * height_m) - (5.08 * age_years)
    elif gender.lower() == "female":
        bmr = 43 + (7.38 * weight_kg) + (607 * height_m * 100) - (2.31 * age_years)

    # Adjust BMR based on activity level
    calories_burned = bmr * activity_factor

    return calories_burned



def calculate_jogging_distance(height_cm, gender, jogging_steps):
    """
    Calculate jogging distance based on height, gender, and number of steps.

    Parameters:
    - height_cm (float): Height in centimeters
    - gender (str): Gender ('male' or 'female')
    - jogging_steps (int): Number of steps taken during jogging

    Returns:
    - jogging_distance_km (float): Jogging distance in kilometers
    """
    # Source: 
    if gender.lower() == 'male':
        step_length_cm = 0.415 * height_cm
    elif gender.lower() == 'female':
        step_length_cm = 0.413 * height_cm
    else:
        raise ValueError("Gender should be 'male' or 'female'")

    # Convert step length from cm to km
    step_length_km = step_length_cm / 100000

    # Calculate total distance in km
    jogging_distance_km = jogging_steps * step_length_km

    return jogging_distance_km



def calculate_flights_climbed(stairs_steps):
    steps_per_flight = 16  # Number of steps per flight
    
    # Calculate flights climbed
    flights_climbed = stairs_steps / steps_per_flight

    return flights_climbed