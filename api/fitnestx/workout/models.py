from django.db import models
from fitnestx.users.models import User

class Equipment(models.Model):
    equipment_image = models.ImageField(upload_to='equipment_img/', null=True, blank=True)
    name = models.CharField(max_length=50)
    description = models.TextField()

    def __str__(self):
        return self.name

class Exercise(models.Model):
    exercise_image = models.ImageField(upload_to='exercise_img/', null=True, blank=True)
    name = models.CharField(max_length=50)
    description = models.TextField()
    difficulty = models.CharField(max_length=25)
    calories_burn = models.IntegerField()
    custom_repeats = models.IntegerField()
    time_required = models.CharField(max_length=25)

    def __str__(self):
        return self.name

class ExercisePerform(models.Model):
    header = models.CharField(max_length=100)
    description = models.TextField()
    step_no = models.IntegerField()
    exercises = models.ManyToManyField(Exercise)

    def __str__(self):
        return self.header
    
class Workout(models.Model):
    workout_image = models.ImageField(upload_to='workout_img/', null=True, blank=True)
    name = models.CharField(max_length=100)
    time_required = models.DurationField()
    total_calories = models.IntegerField()
    difficulty = models.CharField(max_length=20)
    exercise_count = models.IntegerField(default=0) 
    exercises = models.ManyToManyField(Exercise, through='WorkoutExercise')
    equipments = models.ManyToManyField(Equipment)

    def __str__(self):
        return self.name
    
    def save(self, *args, **kwargs):
        sum_calories = sum(exercise.calories_burn for exercise in self.exercises.all())
        self.total_calories = sum_calories
        self.exercise_count = self.exercises.count()
        super().save(*args, **kwargs)

class WorkoutExercise(models.Model):
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE, related_name='workout_exercise')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    set_count = models.IntegerField()

    def __str__(self):
        return f"{self.workout.name} - {self.exercise.name} ({self.set_count} sets)"

class WorkoutSchedule(models.Model):
    SCHEDULE_STATUS = (("Pending", "Pending"),("Completed", "Completed"))
    
    date = models.DateField()
    time = models.TimeField()
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE)
    user = models.ForeignKey(User, related_name='workout_schedule_user', on_delete=models.CASCADE)
    notification_note = models.TextField(blank=True)
    notify_status = models.BooleanField(default=False)
    status = models.CharField(max_length=15, choices=SCHEDULE_STATUS, default="Pending")

    class Meta:
        unique_together = ('date', 'time', 'user')

    def __str__(self):
        return f"{self.date} - {self.time} - {self.workout.name} - {self.user.username}"