import numpy as np
import tensorflow as tf
from datetime import datetime
import config.settings.base as settings

model = tf.keras.models.load_model(settings.MODEL_FILEPATH)

def predict_sensor_data(sensor_data):
    data = np.array(sensor_data['data'])  # Convert to NumPy array
    data = np.expand_dims(data, axis=0)   # Add batch dimension

    # Make predictions
    predictions = model.predict(data)

    class_labels = {0: 'Walking', 1: 'Jogging', 2: 'Stairs', 3: 'Sitting', 4: 'Standing'}

    predicted_class_index = np.argmax(predictions)
    predicted_class_label = class_labels[predicted_class_index]

    # Set the predicted activity and current date and time
    sensor_data['predicted_activity'] = predicted_class_label
    sensor_data['date_and_time'] = datetime.now()

    return sensor_data

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
    if gender.lower() == "male":
        bmr = 260 + (9.65 * weight_kg) + (573 * height_m) - (5.08 * age_years)
    elif gender.lower() == "female":
        bmr = 43 + (7.38 * weight_kg) + (607 * height_m * 100) - (2.31 * age_years)

    # Adjust BMR based on activity level
    calories_burned = bmr * activity_factor

    return calories_burned

def calculate_jogging_distance(height_cm, age_years, gender, jogging_steps):
    
    height_inche = height_cm / 2.54  # Convert height from cm to inches
    
    # Constants for estimating distance per step
    if gender.lower() == "male":
        step_length = 0.415 * height_inche
    elif gender.lower() == "female":
        step_length = 0.413 * height_inche
        
    steps_per_km = 1089 / step_length      # Number of steps in a kilometer
    
    # Calculate distance based on number of steps
    distance_km = jogging_steps / steps_per_km

    return distance_km

def calculate_flights_climbed(stairs_steps):
    steps_per_flight = 16  # Number of steps per flight
    
    # Calculate flights climbed
    flights_climbed = stairs_steps / steps_per_flight

    return flights_climbed