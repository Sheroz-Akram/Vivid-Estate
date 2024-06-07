from ..models import *
from django.http import JsonResponse

# Check If a User is Login or Not.
# Verify (Email, Private Key) of a user
def checkUserLogin(request):

    try:
        # Make Sure it is POST Request
        if request.method == "POST":

            # Get the other data files
            Email = request.POST['Email']
            PrivateKey = request.POST['PrivateKey']

            # Get the User
            try:
                # Find the User with Email Address
                user = ApplicationUser.objects.get(email_address=Email)

                # Check the User Password
                if user.private_key != PrivateKey:
                    return False, "Private Key Not Verified"

                # User is now authenticated
                return True, user

            # User Not Found
            except Exception as e:
                return False, "User not found. Incorrect Email Address"
    
    # POST Parameters Not Found
    except e:
        return False, "POST Parameters not found"
    
    # The request is not POST 
    return False, "Invalid HTTP Request"

# Give the HTTP User an Error Json Response
def httpErrorJsonResponse(message):
    return JsonResponse({"status":"error", "message": message})

# Give the HTTP User an Success Json Response
def httpSuccessJsonResponse(message):
    return JsonResponse({"status":"success", "message": message})
