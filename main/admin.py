from django.contrib import admin
from .models import Calender,TimePlannerTask,CustomUser,Subscribers,APIdataStorage,Planner
from django.contrib.auth.admin import UserAdmin


admin.site.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    model = CustomUser
    list_display = ('email', 'name', 'is_staff', 'is_active', 'date_joined')
    list_filter = ('is_staff', 'is_active')
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Info', {'fields': ('name',)}),
        ('Permissions', {'fields': ('is_staff', 'is_active', 'is_superuser')}),
        ('Important Dates', {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2'),
        }),
    )
    search_fields = ('email', 'name')
    ordering = ('email',)





# Register your models here.
admin.site.register(Calender)
class CalenderAdmin(admin.ModelAdmin):
    list_display = ['id','title']




admin.site.register(TimePlannerTask)
class TimePlannerTaskAdmin(admin.ModelAdmin):
    list_display = ['id','title']





admin.site.register(Subscribers)
class SubscribedClassesAdmin(admin.ModelAdmin):
    list_display = ['id','title']


admin.site.register(APIdataStorage)
class APIdataStorageAdmin(admin.ModelAdmin):
    list_display = ['id','identifier']


admin.site.register(Planner)
class PlannerAdmin(admin.ModelAdmin):
    list_display = ['id','title']

