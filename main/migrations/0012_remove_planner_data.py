# Generated by Django 4.2.3 on 2023-09-07 18:17

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0011_planner_color'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='planner',
            name='data',
        ),
    ]
