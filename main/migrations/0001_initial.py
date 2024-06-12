# Generated by Django 4.2.3 on 2023-08-09 05:30

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='CustomUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('email', models.EmailField(max_length=254, unique=True)),
                ('name', models.CharField(blank=True, max_length=254, null=True)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_superuser', models.BooleanField(default=False)),
                ('is_active', models.BooleanField(default=True)),
                ('last_login', models.DateTimeField(blank=True, null=True)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Calender',
            fields=[
                ('id', models.CharField(max_length=255, primary_key=True, serialize=False)),
                ('title', models.CharField(default='', max_length=255)),
                ('color', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='TimePlannerTask',
            fields=[
                ('id', models.CharField(max_length=255, primary_key=True, serialize=False)),
                ('title', models.CharField(default='', max_length=255)),
                ('minutes_duration', models.IntegerField(default=0)),
                ('days_duration', models.IntegerField(blank=True, null=True)),
                ('day', models.IntegerField(default=0)),
                ('minutes', models.IntegerField(default=0)),
                ('hour', models.IntegerField(default=0)),
                ('color', models.CharField(blank=True, max_length=255, null=True)),
                ('repetition', models.IntegerField(default=0)),
                ('additional_data', models.JSONField(blank=True, null=True)),
                ('section_code', models.CharField(blank=True, max_length=255, null=True)),
                ('term', models.CharField(blank=True, max_length=255, null=True)),
                ('instructor', models.CharField(blank=True, max_length=255, null=True)),
                ('location', models.CharField(blank=True, max_length=255, null=True)),
                ('final', models.CharField(blank=True, max_length=255, null=True)),
                ('calender', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.calender')),
            ],
        ),
        migrations.CreateModel(
            name='SubscribedClasses',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('class_id', models.CharField(blank=True, default='', max_length=5000, null=True)),
                ('title', models.CharField(blank=True, max_length=500, null=True)),
                ('class_type', models.CharField(blank=True, max_length=5000, null=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
