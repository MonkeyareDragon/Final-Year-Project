from django.db import models
from django.db.models.signals import m2m_changed
from django.dispatch import receiver

class Equipment(models.Model):
    name = models.CharField(max_length=50)
    description = models.TextField()

    def __str__(self):
        return self.name

class Exercise(models.Model):
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
    name = models.CharField(max_length=100)
    time_required = models.DurationField()
    calories_burn = models.IntegerField()
    difficulty = models.CharField(max_length=20)
    exercise_count = models.IntegerField(default=0) 
    exercises = models.ManyToManyField(Exercise, through='WorkoutExercise')
    equipments = models.ManyToManyField(Equipment)

    def __str__(self):
        return self.name

class WorkoutExercise(models.Model):
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE, related_name='workout_exercise')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    set_count = models.IntegerField()

    def __str__(self):
        return f"{self.workout.name} - {self.exercise.name} ({self.set_count} sets)"
