# Generated by Django 4.2.11 on 2024-03-28 13:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('meal', '0002_remove_food_ingredients_remove_food_nutritions_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='ingredient',
            name='name',
            field=models.CharField(max_length=50, unique=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='name',
            field=models.CharField(max_length=50, unique=True),
        ),
    ]
