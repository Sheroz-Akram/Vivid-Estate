from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from ..modules.ocr import getCnicDetails
from ..modules.mail import send_email
from ..modules.helper import *
import uuid
import os
from django.core.files.storage import FileSystemStorage
from ..models import *
import random
import string
from geopy.geocoders import Nominatim
import json

# Import Application Components
from ..Components.UserComponent import *


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
                fs = FileSystemStorage(location=settings.FILESTORAGE)

                # Save the file directly
                fileNewName = "file_" + str(uuid.uuid4()) + imageFile.name
                filename = fs.save(fileNewName, imageFile)

                # Store the File Path
                user.cnic_file = fileNewName
                user.save()

                # Perform the OCR Operation
                result['status'] = "success"
                result['result'] = getCnicDetails(fileNewName)

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
            Langitude = request.POST['Langitude']
            Longitude = request.POST['Longitude']

            # Locate the location of the user
            geolocator = Nominatim(user_agent="VividEstate")
            location = geolocator.reverse((Langitude, Longitude),language="en")
            address = location.raw['address']


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
                        feedback=0,
                        location= ', '.join(address.values()),
                        user_type=Type,
                        langitude=Langitude,
                        longitude=Longitude
                ) 

                print("OTP Generated: "+ otp)

                user.save()

                # Send OTP Through Mail Service
                send_email(subject="Verify Email Address - Vivid Estate", body="Verify your email address! Please enter the following otp in Vivid Estate: " + otp, recipients=[Email])

                # Display Message to the User
                return JsonResponse({"status":"success", "message":"Great Done"})
            
            except Exception as e:
                return JsonResponse({"status":"error", "message":"User existed already" + str(e)})

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
    
    # Log The Terminal
    print(f"=> Resend OTP Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the other data files
        email = request.POST['Email']
        password = request.POST['Password']

        # Generate a new OTP 
        newOTPCode = str(random.randint(1000, 9999))

        # Create instance of User Component
        userComponent = UserComponent()

        # Now Perform the Resend OTP Request
        result = userComponent.resendOTP(email,password, newOTPCode)
        
        # Check the Status of our Request
        if result[0] == True:
            return httpSuccessJsonResponse(result[1])
        else:
            return httpErrorJsonResponse(result[1])

    except Exception as e:
        return JsonResponse({"status":"error", "message": "Invalid Request"})



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

    # Log The Terminal
    print(f"=> Login Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            email = request.POST['Email']
            password = request.POST['Password']

            # Create a User Object
            userComponent = UserComponent()

            # Perform the Login Request
            result = userComponent.login(email, password, generate_random_string(50))

            # If Request is Success
            if result[0] == True:

                # Response the User Data Back To Client
                return JsonResponse(
                    {
                        "status":"success",
                        "message":"Account Login is Successfull", 
                        "privateKey" : userComponent.getPrivateKey(), 
                        "userType" : userComponent.getUserType(), 
                        "profilePicture": userComponent.getProfilePicture()
                    })
            
            else:
                # Response an Error to User
                return JsonResponse(
                    {
                        "status":"error", 
                        "message": result[1]
                    })

    # Something Wrong Happens in the Request
    except Exception as e:
        print(e)
        return JsonResponse({"status":"error", "message": "Invalid Request"})


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

# Delete the User Account
@csrf_exempt
def deleteAccount(request):

    # Log The Terminal
    print(f"=> Account Deletion Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data from Post Request
        email = request.POST['Email']
        password = request.POST['Password']
        privateKey = request.POST['PrivateKey']

        # Create User Component Object
        userComponent = UserComponent()

        # Perform the Deleteion Operation
        result = userComponent.deleteAccount(email, password, privateKey)

        # Check The Status Of our response
        if result[0] == True:
            return httpSuccessJsonResponse("User Account Deleted Successfully")
        else:
            return httpErrorJsonResponse(result[1])

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Invalid Request")

# Get the profile data of a User
@csrf_exempt
def getUserProfileData(request):

    # Log The Terminal
    print(f"=> User Profile Data Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the Data from Post Request
        email = request.POST['Email']
        privateKey = request.POST['PrivateKey']

        # Create Instance of User Component
        userComponent = UserComponent()

        # Perform the User Authenticate
        result = userComponent.authenticateUser(email, privateKey)

        # Check the Status of our Response
        if result[0] == True:

            # Get the User Model Object
            userModel = result[2]

            # Get Our Profile Picture
            return httpSuccessJsonResponse({
                "profilePic": userModel.profile_pic,
                "userFullName": userModel.full_name,
                "userName": userModel.user_name,
                "cnicNumber": userModel.cnic_number,
                "dob": userModel.cnic_dob,
                "feedbackRating": userModel.feedback
            })

        else:
            return httpErrorJsonResponse(result[1])

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")


# Get the profile data of a Seller
@csrf_exempt
def getSellerProfileData(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])
    
    # Now we Get the User
    user = authResult[1]

    # Now We Perform Our Operations
    try:

        # Get the Payload
        SellerID = request.POST['SellerID']

        # Now We Find Seller By Its ID
        seller = ApplicationUser.objects.get(id=SellerID)

        # Now Find All The Ads of the Seller
        seller_ads = Property.objects.filter(seller=seller)

        # Store The Data of Seller Property
        seller_ads_data = []

        # Check If We Have More Than One Property
        if seller_ads.count() > 0:

            # Now We Looop Through Each Property
            for ad in seller_ads:

                # Get the First Image Of the Property
                picture = PropertyImage.objects.filter(propertyID=ad).first()

                # Get The Details of the Property
                seller_ads_data.append({
                    "PropertyID": ad.id,
                    "PropertyImage": picture.imageLocation,
                    "Price": ad.price,
                    "Location": ad.abstractLocation,
                    "TimeAgo": ad.days_ago(),
                    "Views": ad.views,
                    "Likes": ad.likes
                })

        # Get Our Profile Picture
        return httpSuccessJsonResponse({
            "SellerName": seller.full_name,
            "TotalAdsPublish": seller_ads.count(),
            "SellerEmail": seller.email_address,
            "ProfilePicture": seller.profile_pic,
            "Ads": seller_ads_data
        })

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")


# Update the profile picture of a user in the server
@csrf_exempt
def updateProfilePicture(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now we get update our profile picture
    try:
        # Get the Image Data
        imageFile = request.FILES['cnicImage']

        # Create or get an instance of FileSystemStorage to handle saving
        fs = FileSystemStorage(location=settings.FILESTORAGE)
        
        # Save the file directly
        fileNewName = "file_" + str(uuid.uuid4()) + imageFile.name
        filename = fs.save(fileNewName, imageFile)

        # Delete the previous profile picture of the user
        fs.delete(user.profile_pic)

        # Store the File Path
        user.profile_pic = fileNewName
        user.save()

        return httpSuccessJsonResponse("Profile picture has been update successfully")

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")



# Update the profile data of a user in the server
@csrf_exempt
def updateProfileData(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now we get update our profile data
    try:

        # Get the Data to Update for the User
        fullName = request.POST['FullName']
        cnicNumber = request.POST['CnicNumber']
        cnicDob = request.POST['CnicDOB']

        # Update the Data of the User
        user.full_name = fullName
        user.cnic_number = cnicNumber
        user.cnic_dob = cnicDob
        user.save()

        return httpSuccessJsonResponse("Profile Data has been updated successfully")

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")



# Update the feedback of the user
@csrf_exempt
def updateFeedback(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])

    # Now we Get the User
    user = authResult[1]

    # Now we get update our user feedback
    try:

        # Get the Data to Update for the User
        feedback = request.POST['Feedback']

        # Update the Data of the User
        user.feedback = feedback
        user.save()

        return httpSuccessJsonResponse("Feedbac has been updated successfully")

    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request")

