import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

class Seller extends User {
  // Create a new Property Ad in the Server
  void submitNewPropertyAdd(BuildContext userContext,
      List<dynamic> propertyImages, Map<String, Object> PropertyData) async {
    // Our API End Point
    var host = ServerInfo().host;
    var url = Uri.parse("$host/submit_new_ad");

    // Submit the Data
    try {
      // Create a new Request
      var request = http.MultipartRequest('POST', url);

      // Now we get our Images
      var index = 1;
      for (var propertyImage in propertyImages) {
        // Get Our Image to upload
        var imageUpload = await http.MultipartFile.fromPath(
            'PropertyImage$index', propertyImage?.path ?? "Error");
        index++;

        // Add our Image to our request
        request.files.add(imageUpload);
      }

      // Add Other Fields (consider strong typing)
      request.fields["Email"] = emailAddress;
      request.fields["PrivateKey"] = privateKey;
      request.fields["PicturesCount"] = propertyImages.length.toString();
      request.fields["PropertyData"] = jsonEncode(PropertyData);

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

        // Pop Out of the Page is it is Successfull
        Navigator.pop(userContext);
      }
    } catch (e) {
      // An error has error in sending the file
      ScaffoldMessenger.of(userContext).showSnackBar(
          const SnackBar(content: Text("A network error has occured")));
    }
  }
}
