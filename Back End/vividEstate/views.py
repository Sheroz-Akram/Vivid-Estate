from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt

def HomePage(request):
    return HttpResponse("Home Page is Working Fine.")

