from django.urls import path
from .views import *

urlpatterns = [
    path('calendars/', CalendarAPIView.as_view(), name='calendar-list'),
    path('calendars/<str:id>/', CalenderDetailAPIView.as_view(), name='calendar-detail'),
    path('timeplannertask/', TimePlannerTaskAPIView.as_view(), name='timeplanner-list'),
    path('timeplannertask/get/<str:id>/', TimePlannerTaskAPIView.as_view(), name='timeplanner-list-get'),
    path('timeplannertask/delete/<str:id>/', TimePlannerDetailAPIView.as_view(), name='timeplanner-detail'),
    path('subscribed/classes/post/',SubscribedClassesAPIView.as_view(),name='subscribed-classes-get'),
    path('subscribed/classes/get/',GetSubscribedAPI.as_view(),name='subscribed-classes-post'),
    path('subscribed/classes/delete/',GetSubscribedAPI.as_view(),name='subscribed-classes-delete'),
    path('notifications/push/',send_notification,name='push-notifications'),
    #planner apis
    path('planner/get/',GETPlannerAPIView.as_view(),name='planner-get'),
    path('planner/post/',AddPlannerAPIView.as_view(),name='planner-post'),
    path('planner/delete/<int:id>',PlannerDetailAPIview.as_view(),name='planner-delete'),
    path('planner/update/<int:id>',PlannerDetailAPIview.as_view(),name='planner-update'),
    path('planner/detail/get/',PlannerClassesApiView.as_view(),name='planner-classes-post-get'),
    path('planner/detail/update/',PlannerClassesApiView.as_view(),name='planner-classes-patch'),
    path('planner/detail/delete/',PlannerClassesApiView.as_view(),name='planner-classes-delete'),

]
