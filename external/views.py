from django.shortcuts import render
from django.http import HttpResponse
import requests
# Create your views here.


def getZotisticsData(request):
    response = requests.get("https://api.peterportal.org/rest/v0//grades/raw?instructor=GUERRA, A.&department=PHYSICS&number=7D")
    # /grades/raw?year=2018-19;2019-20&instructor=PATTIS, R.&department=I%26C SCI&quarter=Fall&number=33
    data = response.json()
    print(data)
    return HttpResponse("Hello world")