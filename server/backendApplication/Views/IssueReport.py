from ..modules.helper import *
from django.views.decorators.csrf import csrf_exempt
from ..models import *


# Import our Components
from ..Components.UserComponent import *
from ..Components.ReportingSystem import *


# Submit the Issue of the User
@csrf_exempt
def submitIssueReport(request):

     # Log The Terminal
    print(f"=> Issue Submission Request | IP: {request.META.get('REMOTE_ADDR')}")

    try:
        
        # Get Data from Post Request
        Email = request.POST['Email']
        PrivateKey = request.POST['PrivateKey']
        issueType = request.POST['IssueType']
        issueDate = request.POST["IssueDate"]
        issueDetails = request.POST['IssueDetails']

        try:
            
            # Create User Component for User
            userComponent = UserComponent()

            # Authenticate the Sender
            userComponent.authenticateEmailPrivateKey(Email, PrivateKey)

            # File a new Issue
            ReportingSystem().submitGeneralIssue(issueType,issueDate,issueDetails, userComponent.getUserModel())

            return httpSuccessJsonResponse("Issue Submitted. Admin will review")

        except Exception as e:
            return httpErrorJsonResponse(str(e))

    except Exception as e:
        print(f"-> Exception | {str(e)}")
        return JsonResponse({"status":"error", "message":"Invalid Request"})