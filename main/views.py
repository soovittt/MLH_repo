from django.forms import model_to_dict
from fcm_django.models import FCMDevice
import concurrent.futures
import json
from datetime import datetime, timedelta
import time
import sched
from django.shortcuts import render
from .models import Calender, TimePlannerTask, CustomUser, Subscribers, APIdataStorage, Planner
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import CalendarSerializer, TimePlannerTaskSerializer, SubscribedSerializer, PlannerSerializer
from django.contrib.auth.models import User
from django.contrib.auth import get_user_model
from django.http import JsonResponse
import requests
from threading import Thread
from .constants import *
from firebase_admin.messaging import Message, Notification
from django.core.mail import send_mail
from .helpers import decode_url_encoded
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view


class CalendarAPIView(APIView):
    def get(self, request):

        calendars = Calender.objects.all()
        serializer = CalendarSerializer(calendars, many=True)
        return Response(serializer.data)

    def post(self, request):

        serializer = CalendarSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CalenderDetailAPIView(APIView):

    def get_object(self, pk):

        try:
            return Calender.objects.get(pk=pk)
        except Calender.DoesNotExist:
            return None

    def put(self, request, id):

        calendar = self.get_object(id)
        calendar.title = request.data['title']
        if calendar is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = CalendarSerializer(calendar, data=model_to_dict(calendar))
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, id):

        calendar = self.get_object(id)
        if calendar is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = CalendarSerializer(
            calendar, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        calendar = self.get_object(id)
        if calendar is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        calendar.delete()
        return Response(status=status.HTTP_200_OK)


class TimePlannerTaskAPIView(APIView):

    def post(self, request):
        print("yes called")
        serializer = TimePlannerTaskSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, id):
        calender = Calender.objects.filter(id=id).first()
        timePlannerTask = TimePlannerTask.objects.filter(calender=calender)
        serializer = TimePlannerTaskSerializer(timePlannerTask, many=True)
    
        return Response(serializer.data)


class TimePlannerDetailAPIView(APIView):
    def get_object(self, id):
        try:
            return TimePlannerTask.objects.get(id=id)
        except TimePlannerTask.DoesNotExist:
            return None

    def delete(self, request, id):
        timePlannerTask = self.get_object(id)
        if timePlannerTask is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        timePlannerTask.delete()
        return Response(status=status.HTTP_200_OK)


class SubscribedClassesAPIView(APIView):

    def post(self, request):
        data = request.data

        user_email = data.get('email', '').strip()
        del data['email']
        subscribedClass = Subscribers.objects.filter(
            class_id=data['class_id']).first()
        users = [user.id for user in CustomUser.objects.filter(
            email=user_email)]
        data['user'] = users
        if (subscribedClass is not None):
            subscribedClass.user.add(*users)
            subscribedClass.save()
            return JsonResponse({"response": "sucess"}, status=status.HTTP_200_OK)
        serializer = SubscribedSerializer(data=data)
        if (serializer.is_valid()):
            serializer.save()
            return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class GetSubscribedAPI(APIView):

    def post(self, request):
        data = request.data
        user_email = data.get('email', '').strip()
        users = CustomUser.objects.filter(email=user_email).first()
        subscribed_classes = Subscribers.objects.filter(user=users)
        serializer = SubscribedSerializer(subscribed_classes, many=True)
        return JsonResponse(serializer.data, safe=False)

    def delete(self, request):
        data = request.data
        user_email = data.get('email', '').strip()
        class_id = data.get('class_id', '').strip()
        u = CustomUser.objects.filter(email=user_email).first()
        subscribed_class = Subscribers.objects.filter(
            class_id=class_id).first()
        print(subscribed_class.user.count())
        subscribed_class.user.remove(u)
        if (subscribed_class.user.count() == 0):
            subscribed_class.delete()
        return JsonResponse({"data": "successs"}, status=status.HTTP_200_OK)



class GETPlannerAPIView(APIView):
    def post(self, request):
        data = request.data
        user_email = data.get('email', '').strip()
        user = CustomUser.objects.filter(email=user_email).first()
        planner = Planner.objects.filter(user=user)
        serializer = PlannerSerializer(planner, many=True)
        return JsonResponse(serializer.data, safe=False)


class AddPlannerAPIView(APIView):

    def post(self, request):
        data = request.data
        print(data)
        user_email = data.get('email', '').strip()
        del data['email']
        user = CustomUser.objects.filter(email=user_email).first()
        data['user'] = user.id
        serializer = PlannerSerializer(data=data)
        if (serializer.is_valid()):
            serializer.save()
            return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
        print(serializer.errors)
        return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PlannerDetailAPIview(APIView):



    def patch(self,request,id):
        planner = Planner.objects.filter(id=id).first()
        if planner is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PlannerSerializer(planner,data = request.data,partial=True)
        if(serializer.is_valid()):
            serializer.save()
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)
        

    def delete(self,request,id):
        print(id)
        data = request.data
        user_email = data.get('email', '').strip()
        planner = Planner.objects.filter(id=id).first()
        if(planner is None):
            return Response(status=status.HTTP_404_NOT_FOUND)
        planner.delete()
        return Response(status=status.HTTP_200_OK)





def adjust_index_after_deletion(course_map, deleted_index):
    if deleted_index not in course_map:
        return course_map  # If the index to delete is not in the map, return the original map

    # Remove the key-value pair with the specified index
    del course_map[deleted_index]

    # Adjust the index values of the remaining key-value pairs
    new_index = 1
    for key in course_map:
        course_map[key]['index'] = str(new_index)
        new_index += 1

    return course_map





class PlannerClassesApiView(APIView):

    def get(self,request):
        pass

    def post(self,request):
        data = request.data
        planner_detail = Planner.objects.filter(id=data['id']).first()
        serializer = PlannerSerializer(planner_detail)
        return Response(serializer.data)

    def patch(self,request):
        data = request.data
        planner = Planner.objects.filter(id=data['planner_id']).first()
        print(data)
        class_data = planner.data[data['quarter']]['classes']
        response = requests.get(f'https://api.peterportal.org/rest/v0/courses/{data["department_url_code"]}{data["code"]}')
        response_data =  response.json()
        if(response.status_code==404):
            return Response(response_data['message'],status=status.HTTP_404_NOT_FOUND)
        planner.data[data['quarter']]['classes'][f'{data["department_name"]}-{data["code"]}'] = {'index':str(len(class_data.keys())+1),'units':str(response_data['units'][0])}
        planner.save()
        return Response("Data updated successfully", status=status.HTTP_200_OK)

# {'email': 'sovitn@uci.edu', 'department': 'MATH', 'title': '2B', 'planner_id': '506917', 'quarter': 'Fall-2023'}
# {'Fall-2023': {'id': 1, 'classes': {'Math-2A': {'index': '1', 'units': '4'}, 'Physics-7C': {'index': '2', 'units': '4'}}}, 'Winter-2023': {'id': 2, 'classes': {'Math-2B': {'index': '1', 'units': '4'}, 'Physics-7D': {'index': '2', 'units': '4'}, 'Physics-7LD': {'index': '3', 'units': '4'}}}, 'Spring-2023': {'id': 3, 'classes': {'Math-2D': {'index': '1', 'units': '4'}, 'EECS31': {'index': '2', 'units': '4'}}}, 'Summer-2023': {'id': 4, 'classes': {}}, 'Fall-2024': {'id': 5, 'classes': {}}, 'Winter-2024': {'id': 6, 'classes': {}}, 'Spring-2024': {'id': 7, 'classes': {}}, 'Summer-2024': {'id': 8, 'classes': {}}}




    def delete(self,request):
        data = request.data
        quarter = data['quarter']
        className = data['className']
        planner = Planner.objects.filter(id=data['id']).first()
        class_data = planner.data[quarter]['classes']
        course_map = adjust_index_after_deletion(class_data,className)
        planner.data[quarter]['classes'] = course_map
        planner.save()
        return Response("Data updated successfully", status=status.HTTP_200_OK)





s = sched.scheduler(time.time, time.sleep)

# Set your desired initial time for the first API call (hour, minute, and second)
initial_hour = 23  # Example: 8 AM
initial_minute = 18
initial_second = 0


def fetch_data(dept_code):
    response = requests.get(
        f'https://api.peterportal.org/rest/v0/schedule/soc?term=2023%20Fall&department={dept_code}')
    data = response.json()
    return data


def initial_api_call(sc):
    print("Initial API call...")
    aggregated_data = []
    max_threads = 7
    with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
        futures = [executor.submit(fetch_data, dept_code)
                   for dept_code in uci_dept_list.values()]
        for future in concurrent.futures.as_completed(futures):
            data = future.result()
            aggregated_data.append(data)
    prev_initial_data = APIdataStorage.objects.filter(
        identifier='initial').first()
    if (prev_initial_data is None):
        api_data_comparision = APIdataStorage(
            identifier='initial', api_data=json.dumps(aggregated_data))
        api_data_comparision.save()
    else:
        prev_initial_data.delete()
        api_data_initial = APIdataStorage(
            identifier='initial', api_data=json.dumps(aggregated_data))
        api_data_initial.save()

    print("reached here")
    s.enter(60, 1, comparison_api_calls, (sc,))


def comparison_api_calls(sc):
    print("Comparsion API call...")
    aggregated_data = []
    max_threads = 7
    departments = list(
        set([subscriber.department for subscriber in Subscribers.objects.all()]))
    print(departments)
    with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
        futures = [executor.submit(fetch_data, dept_code)
                   for dept_code in departments]
        for future in concurrent.futures.as_completed(futures):
            data = future.result()
            aggregated_data.append(data)
    prev_comparision_data = APIdataStorage.objects.filter(
        identifier='comparision').first()
    if (prev_comparision_data is None):
        api_data_comparision = APIdataStorage(
            identifier='comparision', api_data=json.dumps(aggregated_data))
        api_data_comparision.save()
    else:
        prev_comparision_data.delete()
        api_data_comparision = APIdataStorage(
            identifier='comparision', api_data=json.dumps(aggregated_data))
        api_data_comparision.save()
    print("comparsion api reached here")
    print("comparision api calculating numbers")
    initial_data = APIdataStorage.objects.filter(
        identifier='initial').first()
    init_data = json.loads(initial_data.api_data)
    notification_already_sent = initial_data.notification_sent
    comparision_data = json.loads(api_data_comparision.api_data)
    subscribed_classes = Subscribers.objects.all()
    for classes in subscribed_classes:
        print(classes.class_id)
        init_num = 0
        comparision_num = 0
        # print(init_data)
        for data in init_data:
            if (len(data["schools"]) > 0):

                if (data["schools"][0]["departments"][0]["deptCode"] == decode_url_encoded(classes.department)):
                    course_index = 0
                    section_index = 0
                    for course in data["schools"][0]["departments"][0]["courses"]:
                        for section in course["sections"]:
                            if (section["sectionCode"] == classes.class_id):
                                init_num = section["numCurrentlyEnrolled"]["totalEnrolled"]

        for data in comparision_data:
            if (len(data["schools"]) > 0):
                if (data["schools"][0]["departments"][0]["deptCode"] == decode_url_encoded(classes.department)):
                    course_index = 0
                    section_index = 0
                    for course in data["schools"][0]["departments"][0]["courses"]:
                        for section in course["sections"]:
                            if (section["sectionCode"] == classes.class_id):
                                print(section["numCurrentlyEnrolled"])
                                comparision_num = section["numCurrentlyEnrolled"]["totalEnrolled"]
        print("comparision num : ", init_num)
        print("comparision num : ", comparision_num)
        if (comparision_num < init_num):

            device = FCMDevice.objects.first()
            print(device)
            message = Message(
                notification=Notification(
                    title=f"Class Vacancy! in {classes.title}", body=f'There is a vacancy in {classes.class_id} {classes.title} {classes.class_type}. Please login into webreg and add your class asap before it gets filled out!'),
                token=device.registration_id
            )
            if (notification_already_sent == False):

                device.send_message(message)
                initial_data.notification_sent = True
                initial_data.save()

        if (comparision_num > init_num):
            device = FCMDevice.objects.first()
            print(device)
            message = Message(
                notification=Notification(
                    title=f"Class getting filled in fast! in {classes.title}", body=f'{classes.class_id} {classes.title} {classes.class_type} is getting filled in fast !. Please login into webreg and add your class asap before it gets filled out!'),
                token=device.registration_id
            )
            if (notification_already_sent == False):
                device.send_message(message)
                initial_data.notification_sent = True
                initial_data.save()

    # This is comparision code

    s.enter(60, 1, comparison_api_calls, (sc,))

# 37210


def run_scheduler():

    now = datetime.now()

    initial_time = now.replace(
        hour=initial_hour, minute=initial_minute, second=initial_second)
    if now > initial_time:
        initial_time += timedelta(days=1)

    initial_interval = (initial_time - now).total_seconds()

    s.enter(initial_interval, 1, initial_api_call, (s,))
    s.run()


def send_notification(request):

    return JsonResponse({"success": "300"}, status=status.HTTP_200_OK)


# thread = Thread(target=run_scheduler)
# thread.start()
