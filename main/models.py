from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models
from django.contrib.auth.models import User
from .managers import UserManager
# Create your models here.


class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(max_length=254, unique=True)
    name = models.CharField(max_length=254, null=True, blank=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    last_login = models.DateTimeField(null=True, blank=True)
    date_joined = models.DateTimeField(auto_now_add=True)

    USERNAME_FIELD = 'email'
    EMAIL_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def get_absolute_url(self):
        return "/users/%i/" % (self.pk)


class Calender(models.Model):
    id = models.CharField(max_length=255, primary_key=True)
    title = models.CharField(max_length=255, default="")
    color = models.CharField(max_length=255)
    user = models.ForeignKey(
        'CustomUser', on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self) -> str:
        return self.title+str(self.id)


class TimePlannerTask(models.Model):
    id = models.CharField(max_length=255, primary_key=True)
    calender = models.ForeignKey(
        Calender, on_delete=models.CASCADE, to_field='id')
    title = models.CharField(max_length=255, default="")
    minutes_duration = models.IntegerField(default=0)
    days_duration = models.IntegerField(null=True, blank=True)
    day = models.IntegerField(default=0)
    minutes = models.IntegerField(default=0)
    hour = models.IntegerField(default=0)
    color = models.CharField(max_length=255, null=True, blank=True)
    repetition = models.IntegerField(default=0)
    additional_data = models.JSONField(blank=True, null=True)
    section_code = models.CharField(max_length=255, null=True, blank=True)
    term = models.CharField(max_length=255, null=True, blank=True)
    instructor = models.CharField(max_length=255, null=True, blank=True)
    location = models.CharField(max_length=255, null=True, blank=True)
    final = models.CharField(max_length=255, null=True, blank=True)
    department = models.CharField(max_length=500,null=True,blank=True)
    code = models.CharField(max_length=500,null=True,blank=True)
    course_type = models.CharField(max_length=500,null=True,blank=True)

    def __str__(self):
        return self.title + str(self.id)


class Subscribers(models.Model):
    class_id = models.CharField(
        max_length=5000, default="", blank=True, null=True)
    title = models.CharField(max_length=500, blank=True, null=True)
    user = models.ManyToManyField(
        'CustomUser', related_name='subscribed_users')
    department = models.CharField(max_length=5000, null=True, blank=True)
    class_type = models.CharField(max_length=5000, blank=True, null=True)
    color = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.title


class APIdataStorage(models.Model):
    id = models.AutoField(primary_key=True)
    identifier = models.CharField(max_length=500)
    api_data = models.JSONField(blank=True, null=True)
    notification_sent = models.BooleanField(
        default=False, blank=True, null=True)

    def __str__(self):
        return self.identifier


class Notification(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=500)
    body = models.CharField(max_length=500)

    def __str__(self):
        return self.title


class Planner(models.Model):
    id = models.CharField(max_length=255, primary_key=True)
    title = models.CharField(max_length=5000)
    user = models.ForeignKey(
        'CustomUser', on_delete=models.CASCADE, null=True, blank=True)
    type = models.CharField(max_length=5000, null=True, blank=True)
    color = models.CharField(max_length=5000, blank=True, null=True)
    major = models.CharField(max_length=5000, blank=True, null=True)
    major_url = models.CharField(max_length=5000, null=True, blank=True)
    data = models.JSONField(null=True,blank=True)

    def __str__(self):
        return self.title


# work
