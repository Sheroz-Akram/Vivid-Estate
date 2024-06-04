import random
import re
import string
from ..models import *
from .InputValidator import *

class AuthenticationSystem:


    def __init__(self):

        self.inputValidator = InputValidator() # Validate the Input of the User


    # Function to Authenticate the Email and Private Key of the User
    def authenticateEmailPrivateKey(self, email:str, privateKey:str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            return False, "Email is not valid."
        
        # Now Perform the Authentication of the User
        try:

            # Find the User from Email Address
            user = ApplicationUser.objects.get(email_address=email)

            # Now check the Private Key of the User
            if user.private_key != privateKey:
                return False, "Private Key not matched."

            # Now Check the Verification Status of User
            if user.verification_status == "No":
                return False, "User is not verified"

            # Return a Success Response
            return True, "User is authenticated", user

        except Exception as e:
            return False, "User not found."


    # Function to Authenticate the Email and Password of the User
    def authenticateEmailPassword(self, email:str, password:str):

        # Validate Email Address
        if not self.inputValidator.validateEmailAddress(email=email):
            return False, "Email is not valid."
        
        # Validate Password
        if not self.inputValidator.validatePassword(password=password):
            return False, "Password is not Valid"
        
        # Now Perform the Authentication of the User
        try:

            # Find the User from Email Address
            user = ApplicationUser.objects.get(email_address=email)

            # Now check the Private Key of the User
            if user.password != password:
                return False, "Password not correct"

            # Now Check the Verification Status of User
            if user.verification_status == "No":
                return False, "User is not verified"

            # Return a Success Response
            return True, "User is authenticated", user

        except Exception as e:
            return False, "User not found."
    



