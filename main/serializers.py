from rest_framework import serializers
from .models import Calender, TimePlannerTask, Subscribers, Planner


class CalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Calender
        fields = '__all__'


class TimePlannerTaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = TimePlannerTask
        fields = '__all__'


class SubscribedSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subscribers
        fields = ('class_id', 'title', 'user',
                  'class_type', 'department', 'color')

    def to_representation(self, instance):
        # Call the parent class's to_representation method to get the default representation
        data = super().to_representation(instance)

        # Remove the 'user' key from the representation
        data.pop('user', None)

        return data


class PlannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Planner
        fields = ('id', 'title', 'user', 'color','type','major','major_url','data')
