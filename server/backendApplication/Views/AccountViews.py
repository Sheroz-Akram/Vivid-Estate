from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from ..modules.ocr import getCnicDetails
from ..modules.mail import send_email
import uuid
import os
from django.core.files.storage import FileSystemStorage
from ..models import *
import random
import string


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
                    return JsonResponse({"status":"error", "result": "Password not correct"})

                # Check if CNIC Data is Already Saved
                if user.cnic_name != "":
                    return JsonResponse({"status":"error", "result": "CNIC data already saved"})

                # Create or get an instance of FileSystemStorage to handle saving
                fs = FileSystemStorage(location=settings.MEDIA_ROOT)

                # Save the file directly
                fileNewName = str(uuid.uuid4()) + imageFile.name
                filename = fs.save(fileNewName, imageFile)
                file_path = os.path.join(settings.MEDIA_ROOT, filename)

                # Store the File Path
                user.cnic_file = file_path
                user.save()

                # Perform the OCR Operation
                result['status'] = "success"
                result['result'] = getCnicDetails(file_path)

                print("OCR Completed!")

                # Successfully OCR the CNIC Card Details
                return JsonResponse(result)

            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "result": "User not found"})

        # Any Error in Operation
        except Exception as e:
            result['status'] = "error"
            result['result'] = {"Take cnic image only or crop."}
            return JsonResponse(result)

    #Invalid Request
    return HttpResponse("Invalid Request..")

# Generate 50 Characters Random Private Key
def generate_random_string(length):
  characters = string.ascii_letters + string.digits + string.punctuation
  result = ''.join(random.choice(characters) for i in range(length))
  return result


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
                otp = str(random.randint(1000, 9999))
                print("**New SignUp Request**")

                # Random Private Key
                privateKey = generate_random_string(50)
                
                # Create Accounts
                user = ApplicationUser(
                        private_key=privateKey,
                        profile_pic="Default.jpg",
                        full_name=FullName,
                        email_address=Email,
                        user_name=User,
                        password=Password,
                        otp_code=str(otp),
                        verification_status="No",
                        user_type=Type
                ) 

                print("OTP Generated: "+ otp)

                user.save()

                # Send OTP Through Mail Service
                send_email(subject="Verify Email Address - Vivid Estate", body="Verify your email address! Please enter the following otp in Vivid Estate: " + otp, recipients=[Email])

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

# Verify a User OTP from POST Request
@csrf_exempt
def verifyPasswordResetOTP(request):
    print("NEW PASSWORD RESET OTP VERIFY Request!!!!")
    try:
        # Make Sure it is POST Request
        if request.method == "POST":
            # Get All the Data
            Email = request.POST['Email']
            Otp = request.POST['OTP']

            # Now need to verify the OTP
                
            # Get the Required Buyer
            user = ApplicationUser.objects.get(email_address=Email)

            result = markVerified(user=user, otp=Otp)

            if result['status'] == "success":
                result['password'] = user.password

            # Mark the OTP as verified
            return JsonResponse(result)

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

# Generate a New OTP for Existing User
@csrf_exempt
def resendOTP(request):
    print("NEW OTP Generation Request")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

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

                # Generate a new OTP 
                otp = str(random.randint(1000, 9999))
                print("OTP Generated: " + otp)

                # Store the new OTP in Data Base
                user.otp_code = otp
                user.verification_status = "No"
                user.save()

                # Send OTP Through Mail Service
                send_email(subject="Resend OTP - Vivid Estate", body="New OTP Generated! Please enter the following otp in Vivid Estate: " + otp, recipients=[Email])

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"New OTP Send Successfully!"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})


# Reset a User Password with a new password
@csrf_exempt
def passwordReset(request):
    print("NEW PASSWORD RESET REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            Password = request.POST['Password']
            NewPassword = request.POST['NewPassword']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.password != Password:
                    return JsonResponse({"status":"error", "message": "Password not correct"})

                # Store the New User Password as Password
                user.password = NewPassword
                user.save()

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"User Password is reset. Now Login"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})


# Login to user account
@csrf_exempt
def loginUser(request):
    print("NEW USER LOGIN REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

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

                # Store the New User Password as Password
                user.private_key = generate_random_string(50)
                user.save()

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Login is successfull!", "privateKey" : user.private_key, "userType" : user.user_type})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})


# Generate a New OTP for Existing User To Reset the Password
@csrf_exempt
def forgotPassword(request):
    print("NEW OTP Generation Request")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Generate a new OTP 
                otp = str(random.randint(1000, 9999))
                print("OTP Generated: " + otp)

                # Store the new OTP in Data Base
                user.otp_code = otp
                user.verification_status = "No"
                user.save()

                # Send OTP Through Mail Service
                send_email(subject="Password Reset OTP - Vivid Estate", body="Password Reset OTP Generated! Please enter the following otp in Vivid Estate: " + otp + " to reset your password.", recipients=[Email])

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Reset Password OTP Send Successfully!"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

# Store the CNIC Data for Existing User
@csrf_exempt
def storeCNICData(request):
    print("NEW CNIC Data UPDATE REQUEST")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            Password = request.POST['Password']
            cnicNumber = request.POST['cnicNumber']
            cnicName = request.POST['cnicName']
            cnicFather = request.POST['cnicFather']
            cnicDob = request.POST['cnicDob']
            

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.password != Password:
                    return JsonResponse({"status":"error", "message": "Password not correct"})

                # Check if CNIC Data is Already Saved
                if user.cnic_name != "":
                    return JsonResponse({"status":"error", "message": "CNIC data already saved"})

                # Store the User CNIC Data
                user.cnic_name = cnicName
                user.cnic_father_name = cnicFather
                user.cnic_number = cnicNumber
                user.cnic_dob = cnicDob

                user.save()

                # Send OTP Through Mail Service
                send_email(subject="CNIC Data Stored - Vivid Estate", body="Your account is created and under verification. Please wait while we verify and approve you account. It would take some time.", recipients=[Email])

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"CNIC Data Stored"})
            
            # If User not found        
            except ApplicationUser.DoesNotExist as e:
                return JsonResponse({"status":"error", "message": "User not found"})

    except Exception as e:
        return JsonResponse({"status":"error", "message": "User not found"})

    return JsonResponse({"status":"error", "message":"Invalid Request"})

