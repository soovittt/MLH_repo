# Generated by Django 4.2.3 on 2023-09-07 18:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0010_calender_user_planner_user'),
    ]

    operations = [
        migrations.AddField(
            model_name='planner',
            name='color',
            field=models.CharField(blank=True, max_length=5000, null=True),
        ),
    ]