from django.contrib import admin
from .models import Equipment, Exercise, Workout, WorkoutExercise, ExercisePerform

class WorkoutExerciseInline(admin.TabularInline):
    model = WorkoutExercise
    extra = 1

class ExercisePerformInline(admin.TabularInline):
    model = ExercisePerform.exercises.through
    extra = 1

class ExerciseAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'description', 'difficulty', 'calories_burn', 'custom_repeats', 'time_required']
    list_filter = ['difficulty']
    search_fields = ['name', 'description']
    inlines = [ExercisePerformInline]

class EquipmentAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'description']
    search_fields = ['name']

class WorkoutAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'time_required', 'calories_burn', 'difficulty', 'exercise_count']
    list_filter = ['difficulty']
    search_fields = ['name']
    inlines = [WorkoutExerciseInline]

class ExercisePerformAdmin(admin.ModelAdmin):
    list_display = ['id', 'header', 'exercises_id', 'step_no']
    search_fields = ['header']

    def exercises_id(self, obj):
        return ", ".join([str(exercise.id) for exercise in obj.exercises.all()])

admin.site.register(Equipment, EquipmentAdmin)
admin.site.register(Exercise, ExerciseAdmin)
admin.site.register(Workout, WorkoutAdmin)
admin.site.register(ExercisePerform, ExercisePerformAdmin)