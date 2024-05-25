from ..models import *
from .InputValidator import *
from .FileHandler import *
from .Mail import *
from ..modules.mail import send_email

class UserComponent:

    # Authenticate The User
    def authenticateUser(self, email: str, privateKey: str):

        # Store the User Input
        self.email = email
        self.privateKey = privateKey

        # Validate the Email Address
        inputValidator = InputValidator()
        if inputValidator.validateEmailAddress(self.email) == False:
            return False, "Email is Not Valid"

        # Perform the Authentication Process
        try:
            # Find the User with Email Address
            user = ApplicationUser.objects.get(email_address=self.email)

            # Check the User Password
            if user.private_key != self.privateKey:
                return False, "Private Key Not Matched"

            # Chek the Verification Status of User
            if user.verification_status == "No":
                return False, "User Account Not Verified"

            # User is now authenticated
            return True, "User Authentication Successfull", user

        # User Not Found
        except Exception as e:
            return False, "User Not Found"
    
    # Authenticate the Email And Password of User
    def authenticateEmailPassword(self, email:str, password:str):

        # Set the Email And Password
        self.email = email
        self.password = password

        # Validate The Email Address
        inputValidator = InputValidator()
        if inputValidator.validateEmailAddress(self.email) == False:
            return False, "Email is Not Valid"
        
        # Find the User with Email Address
        try:
            user = ApplicationUser.objects.get(email_address=self.email)
        except Exception as e:
            return False, "User Not Found"

        # Check the User Password
        if user.password != self.password:
            return False, "Password Not Correct"

        return True, "Email Password Authenticated", user

    # Login A User With His Email And Password
    def login(self, email: str, password: str, newPrivateKey: str):

        # Store the User Input Data
        self.email = email
        self.password = password
        self.privateKey = newPrivateKey

        # Authenticate Email and Password of User
        result = self.authenticateEmailPassword(email, password)

        # Check the Result
        if result[0] == False:
            return result
        
        # Check our User Model
        userModel = result[2]

        # Chek the Verification Status of User
        if userModel.verification_status == "No":
            return False, "User Account Not Verified"
        
        # Update The Private Key Of User
        userModel.private_key = self.privateKey
        userModel.save()

        # Set the User Data
        self.userType = userModel.user_type
        self.profilePicture = userModel.profile_pic

        return True, "User Login Successfully"

    # Delete the Account of User With Profile Picture
    def deleteAccount(self, email:str, password:str, privateKey: str):
        
        # Store the User Input Data
        self.email = email
        self.password = password
        self.privateKey = privateKey

        # Validate The Email Address
        inputValidator = InputValidator()
        if inputValidator.validateEmailAddress(self.email) == False:
            return False, "Email is Not Valid"
        
        # Find the User with Email Address
        try:
            user = ApplicationUser.objects.get(email_address=self.email)
        except Exception as e:
            return False, "User Not Found"

        # Check the User Password
        if user.password != self.password:
            return False, "Password Not Correct"
        
        # Check the Private Key
        if user.private_key != self.privateKey:
            return False, "Private Key Not Matched"

        # Delete the User Profile Picture
        fileHandler = FileHandler()
        fileHandler.deleteFile(user.profile_pic)
        
        # Delete The User Account
        user.delete()

        return True, "Account Deleted"

    # Resend the OTP to the Email Address
    def resendOTP(self, email: str, password: str, newOtp):

        # Authenticate the Email And Password
        result = self.authenticateEmailPassword(email, password)

        # Check the Response
        if result[0] == True:

            # Store the model of User
            userModel = result[2]

            # Store the new OTP in Data Base
            userModel.otp_code = newOtp
            userModel.verification_status = "No"
            userModel.save()


            # Send OTP Through Mail
            mail = Mail("Resend OTP - Vivid Estate")
            mail.addRecipients(email)
            mail.setBody(f"New OTP Generated! Please enter the following otp in Vivid Estate: {newOtp}")
            mail.sendMail()

            return True, "OTP Message Send Successfully"

        else:
            return result


    # Setter

    # Set the Full Name
    def setFullName(self, fullName:str):
        self.fullName = fullName

    # Set the Email Address
    def setEmailAddress(self, email:str):
        self.email = email
    
    # Set the Password
    def setPassword(self, password:str):
        self.password = password

    # Set the Private Key
    def setPrivateKey(self, privateKey:str):
        self.privateKey = privateKey
    
    # Set the User Type
    def setUserType(self, userType:str):
        self.userType = userType

    # Set the Profile Picture
    def setProfilePicture(self, profilePicture:str):
        self.profilePicture = profilePicture

    # Getters

    # Get the Full Name
    def getFullName(self):
        return self.fullName

    # Get the Email Address
    def getEmailAddress(self):
        return self.email
    
    # Get the Password
    def getPassword(self):
        return self.password
     
    # Get the Password
    def getPrivateKey(self):
        return self.privateKey

    # Get the User Type
    def getUserType(self):
        return self.userType

    # Get the Profile Picture
    def getProfilePicture(self):
        return self.profilePicture

