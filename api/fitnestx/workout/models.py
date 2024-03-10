from django.db import models
from fitnestx.users.models import User
from PIL import Image
from django.db.models import Sum, Count

class Equipment(models.Model):
    equipment_image = models.ImageField(upload_to='equipment_img/', null=True, blank=True)
    name = models.CharField(max_length=50)
    description = models.TextField()

    def __str__(self):
        return self.name
    
    def save(self, *args, **kwargs):
        
        self.update_image_size()
        super(Equipment, self).save(*args, **kwargs)
    
    def update_image_size(self):
        image = Image.open(self.equipment_image)
        if image.width > 132 or image.height> 106:
            output_size = (132, 106)
            image.thumbnail(output_size)
            image.save(self.equipment_image.path)

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
    
    def save(self, *args, **kwargs):
        
        self.update_image_size()
        super(Exercise, self).save(*args, **kwargs)
    
    def update_image_size(self):
        image = Image.open(self.exercise_image)
        if image.width > 120 or image.height> 120:
            output_size = (120, 120)
            image.thumbnail(output_size)
            image.save(self.exercise_image.path)

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
    total_calories = models.IntegerField(default=0)
    difficulty = models.CharField(max_length=20)
    exercise_count = models.IntegerField(default=0) 
    exercises = models.ManyToManyField(Exercise, through='WorkoutExercise')
    equipments = models.ManyToManyField(Equipment)

    def __str__(self):
        return self.name
    
    def save(self, *args, **kwargs):
        super(Workout, self).save(*args, **kwargs) 
        
        self.update_calories_and_count()
        self.update_image_size()
        super(Workout, self).save(*args, **kwargs)
        
        
    def update_calories_and_count(self):
        aggregated_data = self.exercises.aggregate(total_calories=Sum('calories_burn'), exercise_count=Count('id'))
        self.total_calories = aggregated_data['total_calories'] or 0
        self.exercise_count = aggregated_data['exercise_count'] or 0
    
    
    def update_image_size(self):
        image = Image.open(self.workout_image)
        if image.width > 150 or image.height> 212:
            output_size = (150, 212)
            image.thumbnail(output_size)
            image.save(self.workout_image.path)

        
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
    check_notification = models.BooleanField(default=False)
    send_notification = models.BooleanField(default=True)

    class Meta:
        unique_together = ('date', 'time', 'user')

    def __str__(self):
        return f"{self.date} - {self.time} - {self.workout.name} - {self.user.username}"