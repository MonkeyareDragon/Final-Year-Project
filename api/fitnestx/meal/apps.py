from django.apps import AppConfig

class ModConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "fitnestx.meal"
    
    # def ready(self):
    #     from fitnestx.meal.meal_scheduler import meal_scheduler_checker
    #     print("Starting Meal Scheduler ...")
    #     meal_scheduler_checker.start()
