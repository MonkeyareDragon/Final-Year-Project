from datetime import timedelta
from django.db import models
from fitnestx.activity.utils import calculate_calories_burned, calculate_flights_climbed, calculate_jogging_distance, get_activity_level, get_age_years, save_calories_burn
from fitnestx.users.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

class SensorData(models.Model):
    user = models.ForeignKey(User, related_name='user_id', on_delete=models.CASCADE)
    data = models.JSONField()
    date_and_time = models.DateTimeField()
    predicted_activity = models.CharField(max_length=10)
    
    def __str__(self):
        return f"Sensor Data {self.user.first_name} on {self.date_and_time}"

class ActivityGoal(models.Model):
    user = models.ForeignKey(User, related_name='activity_user_id', on_delete=models.CASCADE)
    calories_burn = models.PositiveIntegerField(default=0)
    steps = models.PositiveIntegerField(default=0)
    running_distance = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    flights_climbed = models.PositiveIntegerField(default=0)
    
    def _update_calories_burn(self):
        """
        Update the calories burned based on user profile and activity level.
        """
        if self.user and self.user.userprofile:
            user_profile = self.user.userprofile
            height_cm = user_profile.height
            weight_kg = user_profile.weight
            dob = user_profile.dob
            gender = user_profile.gender

            # Calculate age
            age_years = get_age_years(dob)

            # Get activity level
            activity_level = get_activity_level(self.user)

            if height_cm and weight_kg and age_years and gender and activity_level:
                try:
                    calories_burned = calculate_calories_burned(height_cm, weight_kg, age_years, gender, activity_level)
                    self.calories_burn = calories_burned
                except ValueError as e:
                    # Handle invalid activity level
                    # You can log the error or take appropriate action here
                    pass
    
    def _update_steps(self):
        """
        Update the steps based on predicted activity "Walking" from SensorData.
        """
        if self.user:
            self.steps = SensorData.objects.filter(user=self.user, predicted_activity="Walking").count()
    
    def _update_running_distance(self):
        """
        Update the running distance based on jogging steps.
        """
        if self.user:
            jogging_steps = SensorData.objects.filter(user=self.user, predicted_activity="Jogging").count()
            user_profile = self.user.userprofile
            if user_profile:
                height_cm = user_profile.height
                gender = user_profile.gender
                try:
                    jogging_distance_km = calculate_jogging_distance(height_cm, gender, jogging_steps)
                    self.running_distance = jogging_distance_km
                except ValueError as e:
                    print(e)
                    pass
    
    def _update_flights_climbed(self):
        """
        Update the flights climbed based on stairs steps from SensorData.
        """
        if self.user:
            stairs_steps = SensorData.objects.filter(user=self.user, predicted_activity="Stairs").count()
            flights_climbed = calculate_flights_climbed(stairs_steps)
            self.flights_climbed = flights_climbed
    
    def save(self, *args, **kwargs):
        
        self._update_calories_burn()
        self._update_steps()
        self._update_running_distance()
        self._update_flights_climbed()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.user.first_name} activity"

@receiver(post_save, sender=SensorData)
def update_activity_goal_data_on_sensor_data_update(sender, instance, created, **kwargs):
    """
    Signal handler to update all ActivityGoal attributes when SensorData is updated.
    """
    if not created:  # Only update if the SensorData instance was not just created
        user = instance.user
        if user:
            activity_goal, created = ActivityGoal.objects.get_or_create(user=user)
            if activity_goal:
                activity_goal.save()

class SleepTracking(models.Model):
    user = models.ForeignKey(User, related_name='sleep_user_id', on_delete=models.CASCADE)
    sleep_start_time = models.DateTimeField()
    sleep_end_time = models.DateTimeField()
    sleep_duration = models.DurationField()
    sleep_quality = models.CharField(max_length=10)
    notify = models.BooleanField(default=False)

    def __str__(self):
        return f"Sleep Tracking for {self.user.username} on {self.sleep_start_time.date()}"

class WaterIntake(models.Model):
    user = models.ForeignKey(User, related_name='water_user_id', on_delete=models.CASCADE)
    date_time = models.DateTimeField()
    quantity = models.PositiveIntegerField()
    notify = models.BooleanField(default=False)
    
    def __str__(self):
        return f"Water Intake for {self.user.username} on {self.date_time.date()}"