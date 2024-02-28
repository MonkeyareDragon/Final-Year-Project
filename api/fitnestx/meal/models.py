from django.db import models
from fitnestx.users.models import User

class Meal(models.Model):
    meal_image = models.ImageField(upload_to='meal_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    food_count = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.name
    
    def save(self, *args, **kwargs):
        self.food_count = self.foods.count()
        super().save(*args, **kwargs)  

class Category(models.Model):
    category_image = models.ImageField(upload_to='category_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    description = models.TextField()
    foods = models.ManyToManyField(Meal)
    
    def __str__(self):
        return self.name

class Food(models.Model):
    food_image = models.ImageField(upload_to='food_img/', null=True, blank=True)
    name = models.CharField(max_length=50)
    cooking_difficulty = models.CharField(max_length=15)
    time_required = models.PositiveIntegerField()
    calories = models.PositiveIntegerField()
    author = models.CharField(max_length=15)
    description = models.TextField()
    categories = models.ManyToManyField(Category)
    
    def __str__(self):
        return self.name

class Nutrition(models.Model):
    nutrition_image = models.ImageField(upload_to='nutrition_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    quantity = models.FloatField()
    property = models.CharField(max_length=15)
    foods = models.ManyToManyField(Food)
    
    def __str__(self):
        return self.name

class Ingredient(models.Model):
    ingredient_image = models.ImageField(upload_to='ingredient_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    quantity_required = models.CharField(max_length=15)
    foods = models.ManyToManyField(Food)
    
    def __str__(self):
        return self.name

class FoodMakingSteps(models.Model):
    description = models.TextField()
    step_no = models.PositiveIntegerField()
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"Step {self.step_no}: {self.food.name}"
    
class FoodSchedule(models.Model):
    SCHEDULE_STATUS = (("Pending", "Pending"),("Completed", "Completed"))
    
    date = models.DateField()
    time = models.TimeField()
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    user = models.ForeignKey(User, related_name='food_schedule_user', on_delete=models.CASCADE)
    notification_note = models.TextField(blank=True)
    notify_status = models.BooleanField(default=False)
    status = models.CharField(max_length=15, choices=SCHEDULE_STATUS, default="Pending")

    class Meta:
        unique_together = ('date', 'time', 'user')

    def __str__(self):
        return f"{self.date} - {self.time} - {self.food.name} - {self.user.username}"