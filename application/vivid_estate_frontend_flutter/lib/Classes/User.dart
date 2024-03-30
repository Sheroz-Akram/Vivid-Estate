import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Welcome.dart';

class User {
  // Attributes of our User
  late String privateKey;
  late String emailAddress;
  late String profilePictureLocation;
  late String fullName;
  late String username;
  late String cnicNumber;
  late String dob;
  late String userType;

  // Object to Communicate with server
  var server = ServerInfo();

  // Get a User Authentication Data
  dynamic getAuthData() async {
    // Connection to our Shared Prefrences
    var prefs = await SharedPreferences.getInstance();

    // Check if User is already login or not
    var isLogin = prefs.getBool("isLogin");
    if (isLogin == true) {
      // Get the User Information if Already Login
      emailAddress = prefs.getString("userEmail")!;
      privateKey = prefs.getString("privateKey")!;
      userType = prefs.getString("userType")!;

      return true;
    } else {
      return false;
    }
  }

  // Get the User Profile Data
  dynamic getUserProfileData(userContext) async {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};

    // Send Request to Our Server
    await server.sendPostRequest(userContext, "profile_data", sendData,
        (result) {
      if (result['status'] == "success") {
        var data = result['message'];
        profilePictureLocation = "${server.host}/static/" + data['profilePic'];
        fullName = data['userFullName'];
        username = data['userName'];
        cnicNumber = data['cnicNumber'];
        dob = data['dob'];
        return true;
      } else {
        return false;
      }
    });
  }

  // Delete the user Account
  void deleteAccount(userContext, userPassword) async {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};
    sendData['Password'] = userPassword;

    // Send Request to Our Server
    server.sendPostRequest(userContext, "delete_account", sendData, (result) {
      // If Success Logout the User. Account is deleted in the Server
      if (result['status'] == "success") {
        logoutUser(userContext);
      }
      // Display a message. why the request is failed
      else {
        ScaffoldMessenger.of(userContext)
            .showSnackBar(SnackBar(content: Text(result['message'])));
      }
    });
  }

  void submitIssue(userContext, issueType, issueDate, issueDetails) {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};
    sendData['IssueType'] = issueType;
    sendData['IssueDate'] = issueDate;
    sendData['IssueDetails'] = issueDetails;

    // Post Our request
    server.sendPostRequest(userContext, "submit_issue", sendData, (result) {
      if (result['status'] == "success") {
        Navigator.pop(userContext);
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });
  }

  // Logout the User
  void logoutUser(BuildContext context) async {
    // Get our shared preferences to manipulate our local storage
    var prefs = await SharedPreferences.getInstance();

    // Clear all the local data
    prefs.clear();

    // Now replace the current window with the welcome page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WelcomePage()));
  }
}
