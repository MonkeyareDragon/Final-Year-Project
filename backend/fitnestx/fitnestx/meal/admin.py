from django.contrib import admin
from .models import FoodSchedule, Meal, Category, Food, Nutrition, Ingredient, FoodMakingSteps

class FoodAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'cooking_difficulty', 'time_required', 'calories', 'author', 'description']
    search_fields = ['name', 'author']

class MealAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'food_count']
    search_fields = ['name']
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'description']
    search_fields = ['name']

class NutritionAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'quantity', 'property']
    search_fields = ['name']

class IngredientAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'quantity_required']
    search_fields = ['name']

class MealStepAdmin(admin.ModelAdmin):
    list_display = ['id', 'description', 'step_no']
    search_fields = ['description']

class FoodScheduleAdmin(admin.ModelAdmin):
    list_display = ('id', 'date', 'time', 'food', 'user', 'notify_status')
    list_filter = ('date', 'food', 'user', 'notify_status')
    search_fields = ('date', 'food__name', 'user__username')


admin.site.register(Meal, MealAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Food, FoodAdmin)
admin.site.register(Nutrition, NutritionAdmin)
admin.site.register(Ingredient, IngredientAdmin)
admin.site.register(FoodMakingSteps, MealStepAdmin)
admin.site.register(FoodSchedule, FoodScheduleAdmin)