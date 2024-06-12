from django.urls import path
from .views import *

urlpatterns = [
    path('zotistics/get', getZotisticsData, name='calendar-list'),
]
