import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Welcome.dart';
import 'package:vivid_estate_frontend_flutter/Classes/DisplayHelper.dart';
import 'package:vivid_estate_frontend_flutter/Classes/InputValidator.dart';
import 'package:vivid_estate_frontend_flutter/Classes/SharedPreferencesHelper.dart';

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
  late double feedbackRating;
  late double langitude;
  late double longitude;
  late String password;
  late String fathername;
  late String cnic_name;

  // Helper Classes
  var inputValidator =
      InputValidator(); // Input Validator to Check if our input is valid or not
  var displayHelper =
      DisplayHelper(); // Helps to display correct message and reponse to the screen
  var sharedPreferenceHelper =
      SharedPreferencesHelper(); // Helps to Store and Get Information from Shared Preferences

  var serverHelper = ServerInfo(); // Helps to Communicate with  server

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
    await serverHelper.sendPostRequest(userContext, "profile_data", sendData,
        (result) {
      if (result['status'] == "success") {
        var data = result['message'];
        profilePictureLocation =
            "${serverHelper.host}/static/" + data['profilePic'];
        fullName = data['userFullName'];
        username = data['userName'];
        cnicNumber = data['cnicNumber'];
        dob = data['dob'];
        feedbackRating = data['feedbackRating'];
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
    serverHelper.sendPostRequest(userContext, "delete_account", sendData,
        (result) {
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

  // Submit the User Issue to the Server
  void submitIssue(userContext, issueType, issueDate, issueDetails) {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};
    sendData['IssueType'] = issueType;
    sendData['IssueDate'] = issueDate;
    sendData['IssueDetails'] = issueDetails;

    // Post Our request
    serverHelper.sendPostRequest(userContext, "submit_issue", sendData,
        (result) {
      if (result['status'] == "success") {
        Navigator.pop(userContext);
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });
  }

  // Submit the User Profile Data to the Server
  void updateProfileData(userContext, fullName, cnicnNumber, cnicDob) {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};
    sendData['FullName'] = fullName;
    sendData['CnicNumber'] = cnicNumber;
    sendData['CnicDOB'] = cnicDob;

    // Post Our request
    serverHelper.sendPostRequest(userContext, "update_profile", sendData,
        (result) {
      if (result['status'] == "success") {
        Navigator.pop(userContext);
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });
  }

  // Update the feed back rating of the user
  void updateFeedback(userContext, newFeedback) {
    // Now Set the request payload
    var sendData = {"Email": emailAddress, "PrivateKey": privateKey};
    sendData['Feedback'] = newFeedback.toString();

    // Post Our request
    serverHelper.sendPostRequest(userContext, "update_feedback", sendData,
        (result) {
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });
  }

  // Login the User (This will generate a new private key)
  dynamic login(BuildContext context, String email, String password) async {
    // *** 1. Input Data Validation ***
    // 1.1 Email Validation
    if (!inputValidator.validateEmailAddress(email)) {
      displayHelper.displaySnackBar(inputValidator.message, false, context);
      return;
    }
    // 1.2 Password Validation
    else if (!inputValidator.validatePassword(password)) {
      displayHelper.displaySnackBar(inputValidator.message, false, context);
      return;
    }

    // *** 2. Prepare Payload ***
    var sendData = {"Email": email, "Password": password};

    // *** 3. Send Request ***
    // 3.1 Check Reponse Status
    var responseStatus = false;

    // Show Loadin Bar
    displayHelper.displayLoadingbar();

    // 3.2 Perform Request to Server
    await serverHelper.sendPostRequest(context, "login", sendData, (result) {
      // 3.3 Store the Response Status
      responseStatus = result['status'] == "success";

      // 3.4 Success Response from Server
      if (responseStatus) {
        // 3.4.1 Get and Store Data from the Reponse
        sharedPreferenceHelper.storeUserData(email, result['privateKey'],
            result['userType'], result['profilePicture'], password);
        // Store the Type of the User
        userType = result['userType'];
      }

      // 3.5 Display Message to Screen
      displayHelper.displaySnackBar(result['message'], responseStatus, context);
    });

    // Now Stop the Loading bar
    displayHelper.stopLoadingBar(responseStatus);

    // Return the Reponse Status
    return responseStatus;
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

  // Update the profile picture of the user with a new picture
  void updateUserProfilePicture(
      File? profileImage, BuildContext userContext) async {
    // Our API End Point
    var host = ServerInfo().host;
    var url = Uri.parse("$host/update_profile_picture");

    // Send our profilePicture to the server
    try {
      // Get Our Image to upload
      var imageUpload = await http.MultipartFile.fromPath(
          'cnicImage', profileImage?.path ?? "Error");

      var request = http.MultipartRequest('POST', url);

      // Add our profile picture
      request.files.add(imageUpload);

      // Add Other Fields (consider strong typing)
      request.fields["Email"] = emailAddress;
      request.fields["PrivateKey"] = privateKey;

      // Now send our request to the Server
      var response = await request.send();

      // Check our response
      if (response.statusCode == 200) {
        // listen for response
        var responseString = response.stream.transform(utf8.decoder).single;

        // Json Decode the Result
        var result = jsonDecode(await responseString);

        // Display the message
        ScaffoldMessenger.of(userContext)
            .showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      // An error has error in sending the file
      ScaffoldMessenger.of(userContext).showSnackBar(
          const SnackBar(content: Text("A network error has occured")));
    }
  }

  // Get the current location of the user
  Future<void> getCityLocation(context) async {
    // Store Location Permissions
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if Location Permission are enabled or not
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        displayHelper.displaySnackBar(
            "Please enable location service.", false, context);
        await Geolocator.openAppSettings();
      }

      // Request to Get the permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          displayHelper.displaySnackBar(
              "Request to access the location is denied", false, context);
        }
      }

      // Get the user Corrent position in longitude and langitude
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Store the Location Data
      langitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      // Error has occured during location access
      langitude = 0;
      longitude = 0;
    }
  }

  // Send the File Using POST Request to the Server
  dynamic SendPickedFile(Uint8List fileBytes, String fileName, String ChatID,
      BuildContext userContext) async {
    // Store the Response Message from the Server
    var responseMessage = "";

    // Our API End Point
    var host = ServerInfo().host;
    var url = Uri.parse("$host/send_file_message");

    // Send Our file to the Server
    try {
      // Generate File to Upload
      var fileToUpload = http.MultipartFile.fromBytes('SendFile', fileBytes,
          filename: fileName);

      var request = http.MultipartRequest('POST', url);

      // Add our file to upload
      request.files.add(fileToUpload);

      // Add Other Fields (consider strong typing)
      request.fields["Email"] = emailAddress;
      request.fields["PrivateKey"] = privateKey;
      request.fields["ChatID"] = ChatID;

      // Now send our request to the Server
      var response = await request.send();

      // Check our response
      if (response.statusCode == 200) {
        // listen for response
        var responseString = response.stream.transform(utf8.decoder).single;

        // Json Decode the Result
        var result = jsonDecode(await responseString);

        responseMessage = result['message'];
      }
    } catch (e) {
      // An error has error in sending the file
      ScaffoldMessenger.of(userContext).showSnackBar(
          const SnackBar(content: Text("A network error has occured")));
    }

    return responseMessage;
  }
}
