from django.db import models

class Workout(models.Model):
    name = models.CharField(max_length=255)
    time = models.DurationField()
    calories = models.IntegerField()
    difficulty = models.CharField(max_length=255)
    
    class Meta:
        verbose_name_plural = 'Workouts'

    def __str__(self):
        return self.name

class Exercise(models.Model):
    name = models.CharField(max_length=255)
    difficulty = models.CharField(max_length=255)
    calories_burn = models.IntegerField()
    description = models.TextField()
    repeat = models.IntegerField()
    time = models.DurationField()
    workout = models.ForeignKey(Workout, related_name='workout_exercises', on_delete=models.CASCADE)
    
    class Meta:
        unique_together = ['name', 'description']
        ordering = ['difficulty']
    
    def __str__(self):
        return '%d: %s' % (self.name, self.description)

class Equipment(models.Model):
    workout = models.ForeignKey(Workout, related_name='equipments', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    description = models.TextField()

class ExerciseSteps(models.Model):
    steps_number = models.IntegerField()
    steps_description = models.TextField()
    exercise = models.ForeignKey(Exercise, related_name='steps', on_delete=models.CASCADE)