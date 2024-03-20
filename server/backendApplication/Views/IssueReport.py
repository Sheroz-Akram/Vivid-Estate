from ..modules.helper import *
from django.views.decorators.csrf import csrf_exempt
from ..models import *


# Submit the Issue of the User
@csrf_exempt
def submitIssueReport(request):

    # Check the User Authentications
    authResult = checkUserLogin(request=request)
    if authResult[0] == False:
        return httpErrorJsonResponse(authResult[1])
    
    # Now we Get the User
    user = authResult[1]

    # Now we submit the new user issue report
    try:
        
        # Get the other data files
        issueType = request.POST['IssueType']
        issueDate = request.POST["IssueDate"]
        issueDetails = request.POST['IssueDetails']

        # Now we store the issue of the User
        newIssue = Issue(IssueType=issueType, IssueDate=issueDate, IssueDetails=issueDetails, SubmitBy=user)
        newIssue.save()

        # Return a success response
        return httpSuccessJsonResponse("Issue is submited successfully. Admin will try to resolve the issue as soon as possible.")


    # Something wrong just happen the process
    except Exception as e:
        return httpErrorJsonResponse("Error in the server or an invalid request" + str(e))