from ..models import *


# Other Components
from .Mail import *

class ReportingSystem:

    # Submit a General Issue of the User
    def submitGeneralIssue(self, issueType: str, issueDate, issueDetails, issueUser: ApplicationUser):

        # Now we store the issue of the User
        try:
            newIssue = Issue(
                IssueType=issueType,
                IssueDate=issueDate,
                IssueDetails=issueDetails,
                SubmitBy=issueUser
            )
            newIssue.save()
        except:
            raise Exception("Error saving issue into database")

        
        # Send a Mail to User That his Issue is Submited
        try:
            newMail = Mail("Vivid Estate - Issue Submission")
            newMail.addRecipients(issueUser.email_address)

            # Write Detail Message about the Issue
            newMail.setBody(
                f"""Dear {issueUser.full_name}! A new issue has been submit by your account in Vivid Estate. The Detail of the issue are as follows:
                \nIssue Type: {issueType}
                \nIssue Date: {issueDate}
                \nIssue Detail: {issueDetails}
                \nWe will try our best to resolve your issue. Person from our team may contact you soon.
                \nIf you don't file this issue please contact customer service. Thank You!
                \nbest regards,
                \nVivid Estate Team
                """
            )
            newMail.sendMail()
        
        except:
            raise Exception("Unable to send mail to user")


