import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServerInfo {
  // Store our Server Address
  final host = "http://192.168.137.1:8080";

  // Get a User Authentication Data
  dynamic getAuthData() async {
    // Get the User Data
    var prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString("userEmail");
    var userPrivateKey = prefs.getString("privateKey");

    return {"Email": userEmail, "PrivateKey": userPrivateKey};
  }

  // Send Post Reques to the Server and Get the Response Data
  dynamic sendPostRequest(
      userContext, urlEndPoint, postBody, responseOperation) async {
    var url = Uri.parse("$host/$urlEndPoint");
    try {
      // Our Request
      var response = await http.post(url, body: postBody);

      // Get a Response from the Server
      if (response.statusCode == 200) {
        // Covert our data to Json Data
        var result = jsonDecode(response.body);
        // Operation to Perform When Status 200
        responseOperation(result);
      } else {
        // Operation to Perform when request not Valid
        ScaffoldMessenger.of(userContext).showSnackBar(
            const SnackBar(content: Text("Invalid Network Request")));
      }
    }

    // Error Connecting to Server
    catch (e) {
      // Display the Exception Error
      print("Network Error: $e");
    }
  }
}
