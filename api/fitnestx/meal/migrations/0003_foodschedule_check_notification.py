# Generated by Django 4.2.8 on 2024-03-04 09:03

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("meal", "0002_remove_food_categories_remove_ingredient_foods_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="foodschedule",
            name="check_notification",
            field=models.BooleanField(default=False),
        ),
    ]
