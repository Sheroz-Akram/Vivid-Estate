"""vividEstate URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from . import views
from backendApplication.models import *

admin.site.register(ApplicationUser, ApplicationUserAdmin)
admin.site.register(Chat)
admin.site.register(ChatMessage)
admin.site.register(Issue)
admin.site.register(Property)
admin.site.register(PropertyImage)


urlpatterns = [
    path('admin/', admin.site.urls),
    path("", view=views.HomePage, name="Home Page"),
    path('', include("backendApplication.urls"))
] 
