from django.db import models

class Meal(models.Model):
    name = models.CharField(max_length=25)
    food_count = models.PositiveIntegerField()

class Category(models.Model):
    name = models.CharField(max_length=25)
    description = models.TextField()
    foods = models.ManyToManyField(Meal)

class Food(models.Model):
    name = models.CharField(max_length=50)
    cooking_difficulty = models.CharField(max_length=15)
    time_required = models.PositiveIntegerField()
    calories = models.PositiveIntegerField()
    author = models.CharField(max_length=15)
    description = models.TextField()
    categories = models.ManyToManyField(Category)

class Nutrition(models.Model):
    name = models.CharField(max_length=25)
    quantity = models.FloatField()
    property = models.CharField(max_length=15)
    foods = models.ManyToManyField(Food)

class Ingredient(models.Model):
    name = models.CharField(max_length=25)
    quantity_required = models.CharField(max_length=15)
    foods = models.ManyToManyField(Food)

class MealStep(models.Model):
    description = models.TextField()
    step_no = models.PositiveIntegerField()
    food = models.ForeignKey(Food, on_delete=models.CASCADE)