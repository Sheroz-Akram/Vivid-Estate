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
