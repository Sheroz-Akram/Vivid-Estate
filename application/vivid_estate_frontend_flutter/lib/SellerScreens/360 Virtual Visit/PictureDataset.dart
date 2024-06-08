// Class To Store the Complete Picture
import 'dart:convert';
import 'dart:io';

import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:http/http.dart' as http;

class CompletePicure {
  // Store Each Picture Location Separtely
  String centerPicture = "";
  String topPicture = "";
  String bottomPicture = "";
}

// Store the Pictures of 360 Virtual Visit
class PictureDataset {
  // Store the Coordinates
  int xLocation = 0;
  int yLocation = 1;

  // Store All Our Pictures
  List<CompletePicure> pictureList = [];

  // Display the Current Location on Screen
  String currentlocation() {
    // Look At Bottom Picure
    if (yLocation == 0) {
      return "Bottom";
    }

    // Look At Center Picture
    if (yLocation == 1) {
      return "Center";
    }

    // Look at Top Pictues
    if (yLocation == 2) {
      return "Top";
    }

    return "";
  }

  // Check Picture at Coordinate
  bool havePictureAt(x, y) {
    // Check If Have center picture or not
    if (x >= pictureList.length) {
      return false;
    }

    if (x == -1) {
      return false;
    }

    // Now Get the Picture
    CompletePicure picture = pictureList.elementAt(x);

    // Look At Bottom Picure
    if (y == 0) {
      return picture.bottomPicture.isNotEmpty;
    }

    // Look At Center Picture
    if (y == 1) {
      return picture.centerPicture.isNotEmpty;
    }

    // Look at Top Pictues
    if (y == 2) {
      return picture.topPicture.isNotEmpty;
    }

    return false;
  }

  // Check Picture at Current Location
  bool haveCurrentPicture() {
    return havePictureAt(xLocation, yLocation);
  }

  // Get The Image At Location
  String getImage(x, y) {
    // Now Get the Picture
    CompletePicure picture = pictureList.elementAt(x);

    // Look At Bottom Picure
    if (y == 0) {
      return picture.bottomPicture;
    }

    // Look At Center Picture
    if (y == 1) {
      return picture.centerPicture;
    }

    // Look at Top Pictues
    if (y == 2) {
      return picture.topPicture;
    }

    return "";
  }

  // Remove the Current Picture
  void removePicture() {
    // Now Get the Picture
    CompletePicure picture = pictureList.elementAt(xLocation);

    // Look At Bottom Picure
    if (yLocation == 0) {
      picture.bottomPicture = "";
    }

    // Look At Center Picture
    if (yLocation == 1) {
      picture.centerPicture = "";
    }

    // Look at Top Pictues
    if (yLocation == 2) {
      picture.topPicture = "";
    }
  }

  // New Picture Addition to Current Location
  void addNewPicture(String picturePath) {
    // Picture Object
    CompletePicure picture;

    // Check If Coordinate Already Exists or not
    if (xLocation < pictureList.length) {
      picture = pictureList.elementAt(xLocation);
    }
    // Create and Add New Picture
    else {
      picture = CompletePicure();
      pictureList.add(picture);
    }

    // Place The Image Path at Right Location
    // Bottom Picure
    if (yLocation == 0) {
      picture.bottomPicture = picturePath;
    }

    // Center Picture
    else if (yLocation == 1) {
      picture.centerPicture = picturePath;
    }

    // Top Pictues
    else if (yLocation == 2) {
      picture.topPicture = picturePath;
    }
  }

  // Upload All the Files to the Server for Stitching
  Future<String> uploadToSever() async {
    // Create Server Object and Get Host
    var server = ServerInfo();

    // Upload URL
    final uri = Uri.parse("${server.host}/stitch_panaroma");

    // Create a Multipart Request
    var request = http.MultipartRequest('POST', uri);

    // Add Images to our Request
    int index = 0;
    int imagesCount = 0;
    for (var picture in pictureList) {
      print("bhjgkhfgdkahwgkdgkj gdwhgahkd whd$index");
      // Add Bottom Image If Exists
      if (picture.bottomPicture.isNotEmpty) {
        // Load File
        File file = File(picture.bottomPicture);
        // Attached to Request
        request.files.add(
            await http.MultipartFile.fromPath('image${index}x${0}', file.path));
        imagesCount++;
      }

      // Add Center Image If Exists
      if (picture.centerPicture.isNotEmpty) {
        // Load File
        File file = File(picture.centerPicture);
        // Attached to Request
        request.files.add(
            await http.MultipartFile.fromPath('image${index}x${1}', file.path));
        imagesCount++;
      }

      // Add Top Image If Exists
      if (picture.topPicture.isNotEmpty) {
        // Load File
        File file = File(picture.topPicture);
        // Attached to Request
        request.files.add(
            await http.MultipartFile.fromPath('image${index}x${2}', file.path));
        imagesCount++;
      }

      index++;
    }

    // Add Image Count
    request.fields['ImageCount'] = imagesCount.toString();

    // Now we send our request
    var response = await request.send();

    // Get a Response from the Server
    if (response.statusCode == 200) {
      // listen for response
      var responseString = response.stream.transform(utf8.decoder).single;

      // Json Decode the Result
      var result = jsonDecode(await responseString);

      // If the Result is Success
      if (result['status'] == "success") {
        return result['message'].toString();
      }
    } else {
      return "error";
    }

    return "error";
  }
}
