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

    # Find the User from Email Address
    def findUser(self, email:str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            return False, "Email is not valid."

        try:
            # Find the User from Email Address
            user = ApplicationUser.objects.get(email_address=email)
            
            # Pass the User Back
            return True, "User is found", user

        except Exception as e:
            return False, "User not found"

    # Login A User With His Email And Password
    def login(self, email: str, password: str):

        # Authenticate the Email and Password
        result = self.userAuthenticator.authenticateEmailPassword(email, password)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]
        
        # Update The Private Key Of User
        user.private_key = self.generateRandomPrivateKey()
        user.save()

        return True, "User Login Successfully", user

    # Sign Up a new User to Server
    def signUp(self, fullName: str, email: str, userName : str, password: str, userType: str, latitude: str, longitude: str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            return False, "Email is not valid."
        
        # Validate Password
        if not self.inputValidator.validatePassword(password=password):
            return False, "Password is not Valid"

        # Now Get the Detail Location of the User
        try:
            location = self.geoInfomation.detailLocation(latitude, longitude)
        except:
            return False, "Error in Location Service"

        # Now Generate OTP and Private Key for User
        otpCode = self.generateRandomOTP()
        privateKey = self.generateRandomOTP()

        # Send OTP to User by Email
        mailService = Mail("Vivid Estate - OTP Verify")
        mailService.addRecipients(email)
        try:
            mailService.sendOTP(otpCode)
        except:
            return False, "Mail can't be delivered"

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
            return False, "User already exists"

        # Display Log to Terminal
        print(f"-> Account Created | Name: {newUser.full_name} | Email: {newUser.email_address} | Type: {newUser.user_type}")
        return True, "Account Created Successfully", newUser

    # Reset the Password of the User
    def resetPassword(self, email: str, oldPassword: str, newPassword: str):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPassword(email, oldPassword)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Update the Password of the User
        user.password = newPassword
        user.private_key = self.generateRandomPrivateKey()
        user.save()

        return True, "Password updated", user
    

    # Update the Profile Picture of the User
    def updateProfilePicture(self, email: str, privateKey: str, newProfilePicture):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPrivateKey(email, privateKey)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        try:
            # Delete the Previous Picture of the User
            self.fileHandler.deleteFile(user.profile_pic)

            # Store the New Profile Picture
            fileName = self.fileHandler.storeFile(newProfilePicture)

            # Update the File Name in Server
            user.profile_pic = fileName
            user.save()
        except:
            return False, "Error in storing profile picture"
        
        return True, "Profile Picture Updated", user

    # Update the Profile Picture of the User
    def updateProfileData(self, email: str, privateKey: str, fullName, cnicNumber, cnicDob):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPrivateKey(email, privateKey)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Update the Data of Our User
        user.full_name = fullName
        user.cnic_number = cnicNumber
        user.cnic_dob = cnicDob
        user.save()

        return True, "Profile Data Updated", user


    # Verify the User Through its OTP Code
    def verifyUser(self, email: str, otpCode):

        # Find the User Through Its Email Address
        result = self.findUser(email)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Verify the status of User
        if not user.verification_status == "No":
            return False, "User already verified"
        
        # Verify the OTP
        if not user.otp_code == otpCode:
            return False, "OTP Code is invalid"
        
        # Mark User as Verified
        user.verification_status = "Yes"
        user.save()

        return True, "User OTP is Verified", user


    # Resend OTP of the User
    def resendOTP(self, email: str, password: str):

        # Authenticate the Email and Password
        result = self.userAuthenticator.authenticateEmailPassword(email, password)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Generate New OTP for the User
        otpCode = self.generateRandomOTP()

        # Send OTP to User by Email
        mailService = Mail("Vivid Estate - OTP Resend")
        mailService.addRecipients(email)
        try:
            mailService.sendOTP(otpCode)
        except:
            return False, "Mail can't be delivered"

        # Mark the User a Unverified
        user.verification_status = "No"
        user.otp_code = otpCode
        user.save()

        return True, "OTP is Resend to Email Address", user

    # OCR the CNIC Card and Extract all Information
    def ocrCNIC(self, email: str, password: str, cnicImage):

        # Authenticate the Email and Password
        result = self.userAuthenticator.authenticateEmailPassword(email, password)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Store the CNIC Image File in Server Storage
        cnicFileLocation = self.fileHandler.storeFile(cnicImage)

        # Perfom CNIC OCR
        try:
            ocrResult = getCnicDetails(settings.FILESTORAGE + f"/{cnicFileLocation}")
        except Exception as e:
            print(str(e))
            return False, "Error in CNIC OCR"

        # Store File Location in Database
        user.cnic_file = cnicFileLocation
        user.save()

        return True, "CNIC OCR Successfull", ocrResult

    # Store the Information of CNIC of User
    def storeCNICInformation(self, email: str, password: str, cnicNumber, cnicName, cnicFather, cnicDob):

        # Authenticate the Email and Password
        result = self.userAuthenticator.authenticateEmailPassword(email, password)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Update the CNIC Data of the User
        user.cnic_name = cnicName
        user.cnic_father_name = cnicFather
        user.cnic_number = cnicNumber
        user.cnic_dob = cnicDob
        user.save()

        # Send Email to User
        mailService = Mail("Vivid Estate - CNIC Data Updated")
        mailService.addRecipients(email)
        mailService.setBody("CNIC Data of the your account has been updated. Our team will review your provided information and let you know about your account status shortly. Thank You!")
        mailService.sendMail()

        return True, "CNIC Data Updated", user
    

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

    # Update the Feedback Rating of the User
    def updateFeedbackRating(self, email: str, privateKey: str, newRating):

        # Authenticate the User with Email and Private Key
        result = self.userAuthenticator.authenticateEmailPrivateKey(email, privateKey)

        # Evaluate the Result
        if not result[0]:
            return result
        user = result[2]

        # Update the Feedback Rating
        user.feedback = newRating
        user.save()

        return True, "Feedback Rating Updated", user
    
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



