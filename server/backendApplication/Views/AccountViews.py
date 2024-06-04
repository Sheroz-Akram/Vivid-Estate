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

    # Log The Terminal
    print(f"=> CNIC OCR Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the CNIC Image File From Request
        cnicImageFile = request.FILES['cnicImage']

        # Get Authentication Data of User
        UserEmail = request.POST['Email']
        UserPassword = request.POST['Password']

        # Create a new User Component
        userComponent = UserComponent()

        # Perform the OCR Operation
        result = userComponent.ocrCNIC(email=UserEmail, password=UserPassword, cnicImage=cnicImageFile)

        # Evaluate our Result Response
        if not result[0]:
            return httpErrorJsonResponse(result[1])

        # Send our OCR Data Back to User
        return httpSuccessJsonResponse(result[2])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Generate 50 Characters Random Private Key
def generate_random_string(length):
  characters = string.ascii_letters + string.digits + string.punctuation
  result = ''.join(random.choice(characters) for i in range(length))
  return result

# Registor a new user to the application
@csrf_exempt
def SignUp(request):

    # Log The Terminal
    print(f"=> Sign Up Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data from POST Request
        FullName = request.POST['FullName']
        Email = request.POST['Email']
        UserName = request.POST['User']
        Password = request.POST['Password']
        UserType = request.POST['Type']
        Latitude = request.POST['Latitude']
        Longitude = request.POST['Longitude']

        # Create User Component
        userComponent = UserComponent()

        # Perform User Sign Up
        result = userComponent.signUp(FullName, Email, UserName, Password, UserType, Latitude, Longitude)

        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])
    
    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Verify a User OTP from POST Request
@csrf_exempt
def verify_otp(request):

    # Log The Terminal
    print(f"=> OTP Verification Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get Data From Post Request
        UserEmail = request.POST['Email']
        RequestOTPCode = request.POST['OTP']

        # Mark a Object of User Component
        userComponent = UserComponent()

        # Verify the OTP of User
        result = userComponent.verifyUser(email=UserEmail, otpCode=RequestOTPCode)
        
        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Generate a New OTP for Existing User
@csrf_exempt
def resendOTP(request):
    
    # Log The Terminal
    print(f"=> Resend OTP Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the other data files
        UserEmail = request.POST['Email']
        UserPassword = request.POST['Password']

        # Create instance of User Component
        userComponent = UserComponent()

        # Now Perform the Resend OTP Request
        result = userComponent.resendOTP(email=UserEmail,password=UserPassword)
        
        # Check the Status of our Request
        if result[0] == True:
            return httpSuccessJsonResponse(result[1])
        else:
            return httpErrorJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
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

# Reset a User Password with a new password
@csrf_exempt
def passwordReset(request):

    # Log The Terminal
    print(f"=> Login Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get User Data from POST Request
        Email = request.POST['Email']
        Password = request.POST['Password']
        NewPassword = request.POST['NewPassword']

        # Create a User Component
        userComponent = UserComponent()

        # Update the Password of the User
        result = userComponent.resetPassword(Email, Password, NewPassword)

        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
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
            result = userComponent.login(email, password)

            # If Request is Success
            if result[0] == True:

                # Get our User Object
                user = result[2]

                # Response the User Data Back To Client
                return JsonResponse(
                    {
                        "status":"success",
                        "message": result[1], 
                        "privateKey" : user.private_key, 
                        "userType" : user.user_type, 
                        "profilePicture": user.profile_pic
                    })
            
            else:
                return httpErrorJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
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
    
    # Log The Terminal
    print(f"=> CNIC Data Update Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get User Submit Data from POST Request
        UserEmail = request.POST['Email']
        UserPassword = request.POST['Password']
        cnicNumber = request.POST['cnicNumber']
        cnicName = request.POST['cnicName']
        cnicFather = request.POST['cnicFather']
        cnicDob = request.POST['cnicDob']

        # Create User Component Object
        userComponent = UserComponent()
        result = userComponent.storeCNICInformation(UserEmail, UserPassword, cnicNumber, cnicName, cnicFather, cnicDob)

        # Check the Status of our Request
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
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
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse("User Account Deleted")

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Get the profile data of a User
@csrf_exempt
def getUserProfileData(request):

    # Log The Terminal
    print(f"=> User Profile Data Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the Data from Post Request
        email = request.POST['Email']
        privateKey = request.POST['PrivateKey']

        # Authenticate the User
        authentication = AuthenticationSystem()
        result = authentication.authenticateEmailPrivateKey(email,privateKey)

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

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


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

    # Log The Terminal
    print(f"=> Update Profile Picture Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

         # Get User Data from POST Request
        UserEmailAddress = request.POST['Email']
        UserPrivateKey = request.POST['PrivateKey']
        NewProfilePicture = request.FILES['cnicImage']

        # Create a User Component
        userComponent = UserComponent()

        # Update the Profile Picture
        result = userComponent.updateProfilePicture(UserEmailAddress, UserPrivateKey, NewProfilePicture)

        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Update the profile data of a user in the server
@csrf_exempt
def updateProfileData(request):

    # Log The Terminal
    print(f"=> Update Profile Picture Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

         # Get User Data from POST Request
        UserEmailAddress = request.POST['Email']
        UserPrivateKey = request.POST['PrivateKey']
        fullName = request.POST['FullName']
        cnicNumber = request.POST['CnicNumber']
        cnicDob = request.POST['CnicDOB']

        # Create a User Component
        userComponent = UserComponent()

        # Update the Data of the User
        result = userComponent.updateProfileData(UserEmailAddress, UserPrivateKey, fullName, cnicNumber, cnicDob)

        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})



# Update the feedback of the user
@csrf_exempt
def updateFeedback(request):

    # Log The Terminal
    print(f"=> Update Feedback Rating Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get User Data from POST Request
        UserEmailAddress = request.POST['Email']
        UserPrivateKey = request.POST['PrivateKey']
        NewFeedbackRating = request.POST['Feedback']

        # Create User Component
        userComponent = UserComponent()
        result = userComponent.updateFeedbackRating(email=UserEmailAddress, privateKey=UserPrivateKey, newRating=NewFeedbackRating)

        # Evaluate the Result
        if not result[0]:
            return httpErrorJsonResponse(result[1])
        return httpSuccessJsonResponse(result[1])

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

