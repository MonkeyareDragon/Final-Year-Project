from django.contrib import admin
from .models import FoodSchedule, Meal, Category, Food, Nutrition, Ingredient, FoodMakingSteps, FoodNutrition, FoodIngredient

class FoodNutritionInline(admin.TabularInline):
    model = FoodNutrition
    extra = 1

class FoodIngredientInline(admin.TabularInline):
    model = FoodIngredient
    extra = 1

class FoodAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'cooking_difficulty', 'time_required', 'calories', 'author', 'description']
    search_fields = ['name', 'author']
    inlines = [FoodNutritionInline, FoodIngredientInline]

class NutritionAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']
    search_fields = ['name']

    class FoodNutritionInline(admin.TabularInline):
        model = FoodNutrition
        extra = 1

    inlines = [FoodNutritionInline]

class IngredientAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']
    search_fields = ['name']

    class FoodIngredientInline(admin.TabularInline):
        model = FoodIngredient
        extra = 1

    inlines = [FoodIngredientInline]

class MealAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'food_count']
    search_fields = ['name']

class CategoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'description']
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