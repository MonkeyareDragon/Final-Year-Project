from django.db import models
from fitnestx.users.models import User
from PIL import Image
        
class Food(models.Model):
    food_image = models.ImageField(upload_to='food_img/', null=True, blank=True)
    name = models.CharField(max_length=50)
    cooking_difficulty = models.CharField(max_length=15)
    time_required = models.PositiveIntegerField()
    calories = models.PositiveIntegerField()
    author = models.CharField(max_length=15)
    description = models.TextField()
    
    def __str__(self):
        return self.name
    
    def update_image_size(self):
        image = Image.open(self.food_image)
        if image.width > 132 or image.height> 106:
            output_size = (132, 106)
            image.thumbnail(output_size)
            image.save(self.food_image.path)
    
    def save(self, *args, **kwargs):
        self.update_image_size()
        super(Food, self).save(*args, **kwargs)  

class Nutrition(models.Model):
    nutrition_image = models.ImageField(upload_to='nutrition_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    
    def __str__(self):
        return self.name
    
    def update_image_size(self):
        image = Image.open(self.nutrition_image)
        if image.width > 132 or image.height> 106:
            output_size = (132, 106)
            image.thumbnail(output_size)
            image.save(self.nutrition_image.path)
    
    def save(self, *args, **kwargs):
        self.update_image_size()
        super(Nutrition, self).save(*args, **kwargs)  

class FoodNutrition(models.Model):
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    nutrition = models.ForeignKey(Nutrition, on_delete=models.CASCADE)
    quantity = models.FloatField()
    property = models.CharField(max_length=15)
    
    class Meta:
        unique_together = ('food', 'nutrition')

    def __str__(self):
        return f"{self.food.name} - {self.nutrition.name}"

class Ingredient(models.Model):
    ingredient_image = models.ImageField(upload_to='ingredient_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    
    def __str__(self):
        return self.name
    
    def update_image_size(self):
        image = Image.open(self.ingredient_image)
        if image.width > 100 or image.height> 100:
            output_size = (100, 100)
            image.thumbnail(output_size)
            image.save(self.ingredient_image.path)
    
    def save(self, *args, **kwargs):
        self.update_image_size()
        super(Ingredient, self).save(*args, **kwargs)  

class FoodIngredient(models.Model):
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    ingredient = models.ForeignKey(Ingredient, on_delete=models.CASCADE)
    quantity_required = models.CharField(max_length=15)
    
    class Meta:
        unique_together = ('food', 'ingredient')

    def __str__(self):
        return f"{self.food.name} - {self.ingredient.name}"

class Category(models.Model):
    category_image = models.ImageField(upload_to='category_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    description = models.TextField()
    foods = models.ManyToManyField(Food)
    
    def __str__(self):
        return self.name
    
    def update_image_size(self):
        image = Image.open(self.category_image)
        if image.width > 132 or image.height> 106:
            output_size = (132, 106)
            image.thumbnail(output_size)
            image.save(self.category_image.path)
    
    def save(self, *args, **kwargs):
        self.update_image_size()
        super(Category, self).save(*args, **kwargs)  
        
class Meal(models.Model):
    meal_image = models.ImageField(upload_to='meal_img/', null=True, blank=True)
    name = models.CharField(max_length=25)
    food_count = models.PositiveIntegerField(default=0)
    categorys = models.ManyToManyField(Category)
    
    def __str__(self):
        return self.name
    
    def update_image_size(self):
        image = Image.open(self.meal_image)
        if image.width > 236 or image.height> 148:
            output_size = (132, 106)
            image.thumbnail(output_size)
            image.save(self.meal_image.path)
    
    def save(self, *args, **kwargs):
        self.update_image_size()
        super(Meal, self).save(*args, **kwargs)  

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
    check_notification = models.BooleanField(default=False)
    send_notification = models.BooleanField(default=True)

    class Meta:
        unique_together = ('date', 'time', 'user')

    def __str__(self):
        return f"{self.date} - {self.time} - {self.food.name} - {self.user.username}"