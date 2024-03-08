from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from .modules.ocr import getCnicDetails
import uuid
import os
from django.core.files.storage import FileSystemStorage
from .models import *
import random


# Create your views here.

# API to OCR the CNIC card and return the results
@csrf_exempt
def OcrCNIC(request):
    print("NEW CNIC OCR Request!!!!")
    # Check If Request of of POST Type
    if request.method == "POST":
        
        try:

            # Store the OCR Result Data
            result = {}

            # Get the Image Data
            imageFile = request.FILES['cnicImage']

            # Get the other data files
            Email = request.POST['Email']
            Password = request.POST['Password']

            # Get the User
            try:

                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.password != Password:
                    return JsonResponse({"status":"error", "message": "Password not correct"})
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

            # Create or get an instance of FileSystemStorage to handle saving
            fs = FileSystemStorage(location=settings.MEDIA_ROOT)

            # Save the file directly
            fileNewName = str(uuid.uuid4()) + imageFile.name
            filename = fs.save(fileNewName, imageFile)
            file_path = os.path.join(settings.MEDIA_ROOT, filename)

            # Perform the OCR Operation
            result['status'] = "success"
            result['result'] = getCnicDetails(file_path)

            print("OCR Completed!")
            print(result)

            # Delete File After OCR
            fs.delete(fileNewName)

            # Successfully OCR the CNIC Card Details
            return JsonResponse(result)

        # Any Error in Operation
        except Exception as e:
            result['status'] = "error"
            result['result'] = {"Take cnic image only or crop."}
            return JsonResponse(result)

    #Invalid Request
    return HttpResponse("Invalid Request..")



# Registor a new user to the application
@csrf_exempt
def SignUp(request):
    try:
        
        if request.method == "POST":

            # Get All the Data
            FullName = request.POST['FullName']
            Email = request.POST['Email']
            User = request.POST['User']
            Password = request.POST['Password']
            Type = request.POST['Type']


            ## Save the Data to our database
            try:

                # Generate a OTP
                otp = random.randint(1000, 9999) 
                print("**New SignUp Request**")
                
                # Create Accounts
                user = ApplicationUser(
                        full_name=FullName,
                        email_address=Email,
                        user_name=User,
                        password=Password,
                        otp_code=otp,
                        verification_status="No",
                        user_type=Type
                ) 

                print("OTP:"+otp)

                user.save()

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Great Done"})
            
            except Exception as e:
                return JsonResponse({"status":"error", "message":"User existed already"})

    except Exception as e:
        return JsonResponse({"status":"error", "message":"Invalid Request"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

# Mark OTP as Verified or NOT
def markVerified(user, otp):
    try:
        if user.otp_code == otp:
            if user.verification_status == "Yes":
                return {"status":"error", "message": "User is already verified"}
            else:
                user.verification_status = "Yes"
                user.save()
                return {"status":"success", "message": "OTP is verified"}
        else:
            return {"status":"error", "message": "Not Correct OTP"}
    except:
        return {"status":"error", "message": "user not found"}

# Verify a User OTP from POST Request
@csrf_exempt
def verify_otp(request):
    print("NEW OTP VERIFY Request!!!!")
    try:
        # Make Sure it is POST Request
        if request.method == "POST":
            # Get All the Data
            Email = request.POST['Email']
            Otp = request.POST['OTP']

            # Now need to verify the OTP
                
            # Get the Required Buyer
            user = ApplicationUser.objects.get(email_address=Email)

            # Mark the OTP as verified
            return JsonResponse(markVerified(user=user, otp=Otp))

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})
