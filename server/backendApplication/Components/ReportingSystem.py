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

    # Submit the Report of the User Regarding Property
    def submitPropertyReport(self, property: Property, user: ApplicationUser, issueType, reportDetails):

        # Store new Property Report
        try:
            # Store the Report of the User
            propertyReport = PropertyReport(
                propertyID=property,
                reportingUser=user,
                issueType=issueType,
                reportDetails=reportDetails,
            )
            propertyReport.save()
        except:
            raise Exception("Unable to store new property report")
        

        # Send a Mail to User That his report is Submited
        try:
            newMail = Mail("Vivid Estate - Property Report")
            newMail.addRecipients(user.email_address)

            # Write Detail Message about the Issue
            newMail.setBody(
                f"""Dear {user.full_name}! A new property report has been submit by your account in Vivid Estate. The Detail of the issue are as follows:
                \nIssue Type: {issueType}
                \nIssue Detail: {reportDetails}
                \n\nDetails of Seller and Property:
                \nSeller: {property.seller.full_name}, Seller Email: {property.seller.email_address}
                \nPropertyID: {property.id}, PropertyLocation: {property.abstractLocation}
                \nWe will try our best to resolve your issue. Also removed the property if required. Person from our team may contact you soon.
                \nIf you don't file this issue please contact customer service. Thank You!
                \nbest regards,
                \nVivid Estate Team
                """
            )
            newMail.sendMail()
        
        except:
            raise Exception("Unable to send mail to user")


