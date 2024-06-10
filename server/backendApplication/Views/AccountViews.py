from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from ..modules.helper import *
from ..models import *
import random
import string

# Import Application Components
from ..Components.UserComponent import *
from ..Components.LocationSystem import *
from ..Components.PropertyManager import *

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

        try:

            # Create User Component and Perform Authentication
            userComponent = UserComponent()
            userComponent.authenticateEmailPassword(UserEmail, UserPassword)

            # Perfom the OCR of CNIC
            result = userComponent.ocrCNIC(cnicImageFile)

            # Pass Result back to Application
            return httpSuccessJsonResponse(result)

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


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

        try:
            # Create User Component
            userComponent = UserComponent()

            # Perform User Sign Up
            userComponent.signUp(FullName, Email, UserName, Password, UserType, Latitude, Longitude)

            return httpSuccessJsonResponse("Account Created Successfully")

        except Exception as e:
            return httpErrorJsonResponse(str(e))
    
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

        try:

            # Mark a Object of User Component
            userComponent = UserComponent()

            # Verify the OTP of User
            userComponent.verifyUser(email=UserEmail, otpCode=RequestOTPCode)

            return httpSuccessJsonResponse("OTP is Verified")

        except Exception as e:
            return httpErrorJsonResponse(str(e))
        

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

        try:

            # Create instance of User Component
            userComponent = UserComponent()

            # Authenticate the User
            userComponent.authenticateEmailPassword(UserEmail, UserPassword)

            # Now Perform the Resend OTP Request
            userComponent.resendOTP()

            return httpSuccessJsonResponse("OTP is Resend to Email Address")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Verify a User OTP from POST Request
@csrf_exempt
def verifyPasswordResetOTP(request):
    
    # Log The Terminal
    print(f"=> Password Reset OTP Verification Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get All the Data
        Email = request.POST['Email']
        Otp = request.POST['OTP']

        try:
            # Create a User Component
            userComponent = UserComponent()

            # Verify the OTP Of the User
            userComponent.verifyUser(Email, Otp)

            # Get the User Model
            user = userComponent.getUserModel()

            # Send the Password Back
            return JsonResponse({
                "status": "success",
                "message": "Password Reset OTP Verified",
                "password": user.password
            })
        
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Reset a User Password with a new password
@csrf_exempt
def passwordReset(request):

    # Log The Terminal
    print(f"=> Password Reset Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        # Get User Data from POST Request
        Email = request.POST['Email']
        Password = request.POST['Password']
        NewPassword = request.POST['NewPassword']

        try:
            # Create a User Component
            userComponent = UserComponent()

            # Authenticate the User First
            userComponent.authenticateEmailPassword(Email, Password)

            # Update the Password of the User
            userComponent.resetPassword(NewPassword)

            return httpSuccessJsonResponse("Password Reset Successfully")
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Login to user account
@csrf_exempt
def loginUser(request):

    # Log The Terminal
    print(f"=> Login Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the other data files
        UserEmail = request.POST['Email']
        UserPassword = request.POST['Password']

        try:
            # Create User Component and Perform Authentication
            userComponent = UserComponent()
            userComponent.authenticateEmailPassword(UserEmail, UserPassword)

            # Update the Profile Picture
            userComponent.login()

            # Get our User Model
            user = userComponent.getUserModel()

            # Response the User Data Back To Client
            return JsonResponse(
            {
                "status":"success",
                "message": "Login Successfull", 
                "privateKey" : user.private_key, 
                "userType" : user.user_type, 
                "profilePicture": user.profile_pic
            })

        # Handle Exception and Errors
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})


# Generate a New OTP for Existing User To Reset the Password
@csrf_exempt
def forgotPassword(request):

    # Log The Terminal
    print(f"=> Forgot Password Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:

        # Get the other data files
        Email = request.POST['Email']

        try:

            # Create User Component Object
            userComponent = UserComponent()

            # Perform Password Forgot Operation
            userComponent.forgotPassword(Email)

            return httpSuccessJsonResponse("Password Reset OTP is Send")
        
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
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

        try:
            # Create User Component Object
            userComponent = UserComponent()

            # Authenticate the User
            userComponent.authenticateEmailPassword(UserEmail, UserPassword)

            # Perform the CNIC Storage Operation
            userComponent.storeCNICInformation(cnicNumber, cnicName, cnicFather, cnicDob)

            return httpSuccessJsonResponse("CNIC Data Stored Successfully")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

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

        try:
            # Create User Component Object
            userComponent = UserComponent()

            # Perform the Deleteion Operation
            userComponent.deleteAccount(email, password, privateKey)

            return httpSuccessJsonResponse("User Account Deleted")
        
        except Exception as e:
            return  httpErrorJsonResponse(str(e))

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

        try:
            # Create User Component and Perform Authentication
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(UserEmailAddress, UserPrivateKey)

            # Update the Profile Picture
            userComponent.updateProfilePicture(NewProfilePicture)

            return httpSuccessJsonResponse("Profile Picture Updated")

        # Handle Exception and Errors
        except Exception as e:
            return httpErrorJsonResponse(str(e))

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

        try:
            # Create User Component and Perform Authentication
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(UserEmailAddress, UserPrivateKey)

            # Update the Data of the User
            userComponent.updateProfileData(fullName, cnicNumber, cnicDob)

            return httpSuccessJsonResponse("Profile Data Updated Successfully")

        # Handle Exception and Errors
        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

# Get the Informationn of the Seller Dashboard
@csrf_exempt
def sellerDashboardInfo(request):

    # Log The Terminal
    print(f"=> Seller Dashboard Data | IP: {request.META.get('REMOTE_ADDR')}")

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

            # Our Components
            locationSystem = LocationSystem()
            propertyManager = PropertyManager()

            # Get the List of Ads
            properties = propertyManager.sellerProperties(userModel)
            chats = Chat.objects.filter(Seller=userModel)

            # Combines Views, Likes, Reviews Counts
            Views = 0
            Likes = 0
            Reviews = 0
            TotalRating = 0
            if properties.count() > 0:
                for property in properties:
                    Views = Views + property.views
                    Likes = Likes + property.likes
                    propertyReviews = propertyManager.reviews(property)
                    Reviews = Reviews + propertyReviews.count()

                    # Find All the Ratings
                    TotalPropertyRating = 0
                    if propertyReviews.count() > 0:
                        for review in propertyReviews:
                            TotalPropertyRating = TotalPropertyRating + review.rating
                    AverageRating = 0.0
                    if propertyReviews.count() > 0:
                        AverageRating = TotalPropertyRating / propertyReviews.count()
                    TotalRating = TotalRating + AverageRating

            # Now Calculate the Total Average Rating
            TotalAverageRating = 0.0
            if properties.count() > 0:
                TotalAverageRating = TotalRating / properties.count()

            # Get the address of user using latitude and longitude
            address = locationSystem.queryAddress(userModel.langitude, userModel.longitude)

            # Get Our Profile Picture
            return httpSuccessJsonResponse({
                "profilePic": userModel.profile_pic,
                "userFullName": userModel.full_name,
                "location": address['suburb'] + ", " + address['district'],
                "propertyCount": properties.count(),
                "chatCount": chats.count(),
                "View": Views,
                "Likes": Likes,
                "Reviews": Reviews,
                "AverageRating": TotalAverageRating
            })

        else:
            return httpErrorJsonResponse(result[1])

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

        try:
            # Create User Component and Perform Authentication
            userComponent = UserComponent()
            userComponent.authenticateEmailPrivateKey(UserEmailAddress, UserPrivateKey)

            # Update the Feedback of the User
            userComponent.updateFeedbackRating(NewFeedbackRating)

            return httpSuccessJsonResponse("Feedback Updated")

        # Handle Exception and Errors
        except Exception as e:
            return httpErrorJsonResponse(str(e))


    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})

