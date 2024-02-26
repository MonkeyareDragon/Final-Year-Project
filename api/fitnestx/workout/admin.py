from django.contrib import admin
from .models import Equipment, Exercise, Workout, WorkoutExercise

class WorkoutExerciseInline(admin.TabularInline):
    model = WorkoutExercise
    extra = 1

class ExerciseAdmin(admin.ModelAdmin):
    list_display = ['name', 'description', 'difficulty', 'calories_burn', 'custom_repeats', 'time_required']
    list_filter = ['difficulty']
    search_fields = ['name', 'description']

class EquipmentAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'description']
    search_fields = ['name']

class WorkoutAdmin(admin.ModelAdmin):
    list_display = ['name', 'time_required', 'calories_burn', 'difficulty']
    list_filter = ['difficulty']
    search_fields = ['name']
    inlines = [WorkoutExerciseInline]

admin.site.register(Equipment, EquipmentAdmin)
admin.site.register(Exercise, ExerciseAdmin)
admin.site.register(Workout, WorkoutAdmin)