// This Class Will Validate Different Types of Input from the User
class InputValidator {
  // The Pattern of our email to be validate with
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Parameters to Validate Our Password
  final passwordLength = 8;

  // Store the Error Message during the Validation
  var message = "";

  // Validate the Email Address of the User
  bool validateEmailAddress(String email) {
    // Check if Password is empty
    if (email.isEmpty) {
      message = "Please provide a email address";
      return false;
    }

    // Create a Regex Object
    RegExp regex = RegExp(emailPattern);

    // Perform Validation and return status
    var result = regex.hasMatch(email);

    // Check if email is valid or not
    if (result == false) {
      message = "Enter a valid email address";
    }

    // Send our result back
    return result;
  }

  // Make Sure Password is Strong
  bool validatePassword(String password) {
    // Check if Password is empty
    if (password.isEmpty) {
      message = "Please provide a password";
      return false;
    }

    // Length Requirement
    if (password.length < passwordLength) {
      message = "Password must be of atleast 8 characters";
      return false;
    }

    // Capital Letter Requirement
    bool hasCapital = false;
    for (int i = 0; i < password.length; i++) {
      if (password.codeUnitAt(i) >= 65 && password.codeUnitAt(i) <= 90) {
        hasCapital = true;
        break;
      }
    }

    // Check if Has Capital Letter or not
    if (hasCapital == false) {
      message = "Password must have atleast 1 capital letter";
    }

    return hasCapital;
  }
}
