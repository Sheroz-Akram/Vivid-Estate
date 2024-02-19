from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from .modules.ocr import getCnicDetails
import uuid
import os
from django.core.files.storage import FileSystemStorage


# Create your views here.

# API to OCR the CNIC card and return the results
@csrf_exempt
def OcrCNIC(request):
    # Check If Request of of POST Type
    if request.method == "POST":
        print("NEW CNIC OCR Request!!!!")
        try:
            # Get the Image Data
            imageFile = request.FILES['cnicImage']

            # Create or get an instance of FileSystemStorage to handle saving
            fs = FileSystemStorage(location=settings.MEDIA_ROOT)

            # Save the file directly
            fileNewName = str(uuid.uuid4()) + imageFile.name
            filename = fs.save(fileNewName, imageFile)
            file_path = os.path.join(settings.MEDIA_ROOT, filename)

            # Perform the OCR Operation
            result = getCnicDetails(file_path)
            result['status'] = "sucess"

            # Delete File After OCR
            fs.delete(fileNewName)

            # Successfully OCR the CNIC Card Details
            return JsonResponse(result)

        # Any Error in Operation
        except Exception as e:
            result['status'] = "failed"
            return JsonResponse(result)

    #Invalid Request
    return HttpResponse("Invalid Request..")
