import re

class InputValidator:

    # Validate The Email Address Of the User
    def validateEmailAddress(self, email:str):

        # Pattern For Email Address
        email_pattern = re.compile( r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
        
        # Match the email against the regex pattern
        if re.match(email_pattern, email):

            # The Pattern is match
            return True
        else:

            # Pattern Not Able to Match
            return False

    # Validate the Password of the User
    def validatePassword(self, password):
        
        # Check if Password is empty
        if not password:
            return False

        # Length Requirement
        if len(password) < 8:
            return False

        # Capital Letter Requirement
        has_capital = any(char.isupper() for char in password)

        # Check if Has Capital Letter or not
        if not has_capital:
            return False

        return True
