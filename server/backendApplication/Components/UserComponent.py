from ..models import *


# Import other Modules
from .InputValidator import *
from .AuthenticationSystem import *
from .LocationSystem import *
from .Mail import *
from .FileHandler import *
from .OCR import *
from django.conf import settings
import os

class UserComponent:

    def __init__(self):
        
        # Other Components
        self.inputValidator = InputValidator() # Input Validation Object
        self.geoInfomation = LocationSystem() # Handle Location Service
        self.userAuthenticator = AuthenticationSystem()
        self.fileHandler = FileHandler()

    # Authenticate the User With Email And Password
    def authenticateEmailPassword(self, email: str, password: str):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPassword(email, password)

        # Evaluate the Result
        if not result[0]:
            raise Exception(result[1])
        
        # Store the User Model
        self.user = result[2]

    # Authenticate the User With Email And Private Key
    def authenticateEmailPrivateKey(self, email: str, privateKey: str):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPrivateKey(email, privateKey)

        # Evaluate the Result
        if not result[0]:
            raise Exception(result[1])

        # Store the User Model
        self.user = result[2]

    # Find the User from Email Address
    def findUser(self, email:str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            raise Exception("Email not valid")

        try:
            # Find the User from Email Address
            user = ApplicationUser.objects.get(email_address=email)
            
            # Store the User Information
            self.user = user

        except Exception as e:
            raise Exception("User not found")

    # Login A User With His Email And Password
    def login(self, userType: str):

        # Check the Status of the Account:
        if self.user.account_verification == "Pending":
            raise Exception("Account Verification Pending. Please Wait..")
        
        # Check if Account is Rejected
        if self.user.account_verification == "Rejected":
            raise Exception("Account rejected in verification.")

        # Check if Account is Suspended
        if self.user.account_verification == "Suspended":
            raise Exception("Account is Suspended")
    
        try:
            # Update The Private Key Of User
            self.user.private_key = self.generateRandomPrivateKey()
            self.user.user_type = userType
            self.user.save()
        except Exception as e:
            raise Exception("Unable to Login")


    # Sign Up a new User to Server
    def signUp(self, fullName: str, email: str, userName : str, password: str, userType: str, latitude: str, longitude: str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            raise Exception("Email Address not valid")
        
        # Validate Password
        if not self.inputValidator.validatePassword(password=password):
            raise Exception("Password not valid")

        # Now Get the Detail Location of the User
        try:
            location = self.geoInfomation.detailLocation(latitude, longitude)
        except:
            raise Exception("Location Service Error")

        # Now Generate OTP and Private Key for User
        otpCode = self.generateRandomOTP()
        privateKey = self.generateRandomOTP()

        # Create Account and Save Data in Server
        try:
            newUser = ApplicationUser(
                private_key=privateKey,
                profile_pic="Default.jpg",
                full_name=fullName.title(),
                email_address=email,
                user_name=userName,
                password=password,
                otp_code=str(otpCode),
                verification_status="No",
                feedback=0,
                location=location,
                user_type=userType,
                langitude=latitude,
                longitude=longitude
            )
            newUser.save()
        except:
            raise Exception("User Already Exists")

        # Send OTP to User by Email
        mailService = Mail("Vivid Estate - OTP Verify")
        mailService.addRecipients(email)
        try:
            mailService.sendOTP(otpCode)
        except:
            raise Exception("Error in Mail Service")
        
        # Store the User
        self.user = newUser

        # Display Log to Terminal
        print(f"-> Account Created | Name: {newUser.full_name} | Email: {newUser.email_address} | Type: {newUser.user_type}")

    # Reset the Password of the User
    def resetPassword(self, newPassword: str):

        try:
            # Update the Password of the User
            self.user.password = newPassword
            self.user.private_key = self.generateRandomPrivateKey()
            self.user.save()
        except:
            raise Exception("Unable to Store Password in database")
    

    # Update the Profile Picture of the User
    def updateProfilePicture(self, newProfilePicture):

        try:
            # Delete the Previous Picture of the User
            self.fileHandler.deleteFile(self.user.profile_pic)

            # Store the New Profile Picture
            fileName = self.fileHandler.storeFile(newProfilePicture)

            # Update the File Name in Server
            self.user.profile_pic = fileName
            self.user.save()

        except:
            raise Exception("Error in File Storage Server")

    # Update the Profile Picture of the User
    def updateProfileData(self, fullName, cnicNumber, cnicDob):

        try:
            # Update the Data of Our User
            self.user.full_name = fullName
            self.user.cnic_number = cnicNumber
            self.user.cnic_dob = cnicDob
            self.user.save()

        except:
            raise Exception("Error in database. Unable to update")

    # Verify the User Through its OTP Code
    def verifyUser(self, email: str, otpCode):

        # Find the User Through Its Email Address
        self.findUser(email)

        # Verify the status of User
        if not self.user.verification_status == "No":
            raise Exception("User already verified")
        
        # Verify the OTP
        if not self.user.otp_code == otpCode:
            raise Exception("OTP Code is Invalid")
        
        # Mark User as Verified
        self.user.verification_status = "Yes"
        self.user.save()


    # Resend OTP of the User
    def resendOTP(self):

        # Generate New OTP for the User
        otpCode = self.generateRandomOTP()

        # Send OTP to User by Email
        mailService = Mail("Vivid Estate - OTP Resend")
        mailService.addRecipients(self.user.email_address)
        try:
            mailService.sendOTP(otpCode)
        except:
            return False, "Mail can't be delivered"

        # Mark the User a Unverified
        try:
            self.user.verification_status = "No"
            self.user.otp_code = otpCode
            self.user.save()
        except:
            raise Exception("Unable to Save OTP to Database")

    # OCR the CNIC Card and Extract all Information
    def ocrCNIC(self, cnicImage):


        try:
            # Store the CNIC Image File in Server Storage
            cnicFileLocation = self.fileHandler.storeFile(cnicImage)
        except:
            raise Exception("Error in File Storage while CNIC Image Storage")

        # Perfom CNIC OCR
        try:
            ocrResult = getCnicDetails(settings.FILESTORAGE + f"/{cnicFileLocation}")
        except Exception as e:
            raise Exception("Error in CNIC OCR")

        # Store File Location in Database
        try:
            self.user.cnic_file = cnicFileLocation
            self.user.save()
        except:
            raise Exception("Error in CNIC OCR Database Storage")

        return ocrResult

    # Store the Information of CNIC of User
    def storeCNICInformation(self, cnicNumber, cnicName, cnicFather, cnicDob):

        try:
            # Update the CNIC Data of the User
            self.user.cnic_name = cnicName
            self.user.cnic_father_name = cnicFather
            self.user.cnic_number = cnicNumber
            self.user.cnic_dob = cnicDob
            self.user.save()
        except:
            raise Exception("Uable to Store CNIC Data")

        try:
            # Send Email to User
            mailService = Mail("Vivid Estate - CNIC Data Updated")
            mailService.addRecipients(self.user.email_address)
            mailService.setBody("CNIC Data of the your account has been updated. Our team will review your provided information and let you know about your account status shortly. Thank You!")
            mailService.sendMail()
        except:
            raise Exception("Unable to send mail")

    # User Forgot the Password. Genereate New OTP
    def forgotPassword(self, email: str):

        # Find the User
        self.findUser(email)

        # Generate new OTP Code
        newOTPCode = self.generateRandomOTP()

        # Mail The New OTP To User Email Address
        try:
            mailService = Mail("Vivid Estate - Password Reset OTP")
            mailService.addRecipients(self.user.email_address)
            mailService.sendOTP(newOTPCode)
        except:
            raise Exception("Unable to Send OTP to User")

        # Mark the User as Unverified and Reset OTP
        try:
            self.user.otp_code = newOTPCode
            self.user.verification_status = "No"
            self.user.save()
        except:
            raise Exception("Unable to Save OTP in Database")
        

    # Delete the Account of User With Profile Picture
    def deleteAccount(self, email:str, password:str, privateKey: str):

        # Validate The Email Address
        inputValidator = InputValidator()
        if inputValidator.validateEmailAddress(email) == False:
            raise Exception("Email is Not Valid")
        
        # Find the User with Email Address
        try:
            user = ApplicationUser.objects.get(email_address=email)
        except Exception as e:
            raise Exception("User not found")

        # Check the User Password
        if user.password != password:
            raise Exception("Password not correct")
        
        # Check the Private Key
        if user.private_key != privateKey:
            raise Exception("Private Key Not Matched")

        try:
            # Delete the User Profile Picture
            fileHandler = FileHandler()
            fileHandler.deleteFile(user.profile_pic)
        except:
            raise Exception("Profile Picture not able to Delete")

        # Delete The User Account
        user.delete()

    # Update the Feedback Rating of the User
    def updateFeedbackRating(self, newRating):
        try:
            # Update the Feedback Rating
            self.user.feedback = newRating
            self.user.save()
        except:
            raise Exception("Unable to store feedback")
    
    # Generate New Private Key
    def generateRandomPrivateKey(self):
        characters = string.ascii_letters + string.digits + string.punctuation
        result = ''.join(random.choice(characters) for i in range(50))
        return result

    # Generate New OTP Key
    def generateRandomOTP(self):
        # Generate a OTP
        otp = str(random.randint(1000, 9999))
        return otp

    # Get the User Model
    def getUserModel(self):
        return self.user