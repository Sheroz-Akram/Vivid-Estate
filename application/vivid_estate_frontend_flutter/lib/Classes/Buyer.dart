import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Chat.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Property.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Review.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

class Buyer extends User {
  // Get the Complete Detail of the Property
  Future<Property> getPropertyDetail(
      BuildContext context, String propertyID) async {
    // Create a new Property Object
    Property property = Property(propertyID: propertyID);

    // Now Get the Details of the Property
    await property.retriveCompletePropertyData(
        context, emailAddress, privateKey);

    // Return Our Property Data Back To Post View Page
    return property;
  }

  // Get All The Reviews Of the Property
  Future<List<Review>> getPropertyReviews(
      BuildContext context, String propertyID) async {
    // Create a new Property Object
    Property property = Property(propertyID: propertyID);

    // Now We Send Request to Server
    List<Review> reviewList =
        await property.retriveReviews(context, emailAddress, privateKey);

    return reviewList;
  }

  // Get All The Reviews Of the Property
  Future<bool> submitReview(BuildContext context, String propertyID,
      String comment, int rating) async {
    // Create a new Property Object
    Property property = Property(propertyID: propertyID);

    // Now We Send Request to Server
    bool requestStatus = await property.submitReview(
        context, emailAddress, privateKey, comment, rating);

    return requestStatus;
  }

  // Get the Favourite List From Server
  Future<List<dynamic>> getFavouriteList(BuildContext context) async {
    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
    };

    // Store the Result Data
    var favouriteProperties = [];

    // Send Request to Our Server
    await serverHelper.sendPostRequest(
        context, "get_all_favourites", requestPayload, (result) {
      print(result);
      // Check the Status of Our Request
      if (result['status'] == "success") {
        // Loop Through All The favourites from the list
        for (var i = 0; i < result['message']['PropertiesCount']; i++) {
          // Add Each Property to our result
          favouriteProperties.add({
            "PropertyID": result['message']['Properties'][i]['PropertyID'],
            "Image":
                "${serverHelper.host}/static/${result['message']['Properties'][i]['Image']}",
            "Price": displayHelper
                .formatNumber(result['message']['Properties'][i]['Price']),
            "Location": result['message']['Properties'][i]['Location'],
            "TimeAgo": result['message']['Properties'][i]['TimeAgo'],
            "Views": displayHelper
                .formatNumber(result['message']['Properties'][i]['Views']),
            "Likes": displayHelper
                .formatNumber(result['message']['Properties'][i]['Likes']),
          });
        }
      }
    });

    return favouriteProperties;
  }

  // Perform the Search Operation on Location Based on User Query
  dynamic searchQuery(
      BuildContext userContext, String searchQuery, dynamic filterData) async {
    // Store the Results
    var searchResults = [];

    // Check if user has enter any data or not
    if (searchQuery.length < 3) {
      return searchResults;
    }

    // Data to Send to the Server
    var searchQueryData = {
      "Query": searchQuery,
      "Filter": jsonEncode(filterData)
    };

    // Send Our POST Requst to the Server
    await serverHelper.sendPostRequest(
        userContext, "search_property", searchQueryData, (result) {
      if (result['status'] == "success") {
        for (var element in result['message']['SearchItems']) {
          searchResults.add(element as String);
        }
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });

    return searchResults;
  }

  // Perform Detail Search of the Property
  dynamic detailSearchQuery(
      BuildContext userContext, String searchQuery, dynamic filterData) async {
    // Store the Results
    var searchResults = [];

    // Check if user has enter any data or not
    if (searchQuery.length < 3) {
      return searchResults;
    }

    // Data to Send to the Server
    var searchQueryData = {
      "Query": searchQuery,
      "Filter": jsonEncode(filterData)
    };

    // Send Our POST Requst to the Server
    await serverHelper.sendPostRequest(
        userContext, "search_property_all", searchQueryData, (result) {
      if (result['status'] == "success") {
        for (var element in result['message']['SearchItems']) {
          searchResults.add(element);
        }
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });

    return searchResults;
  }

  // Submit the Report of the Property Add to Admin
  dynamic submitReport(userContext, String propertyID, String ReportType,
      String ReportDetails) async {
    // Variable to Store the Status of our request
    var requestStatus = false;

    // Now Set the request payload
    var sendData = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID,
      "ReportType": ReportType,
      "ReportDetails": ReportDetails,
    };

    // Send Request to Our Server
    await serverHelper.sendPostRequest(userContext, "report_property", sendData,
        (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        requestStatus = true;
      }

      // Display a Status Message to the User
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });

    return requestStatus;
  }

  // Initiate a Chat with a Property Seller
  Future<Chat> initiateChatWithSeller(
      BuildContext context, String sellerEmailAddress) async {
    // Variable to Store the Status of our request
    var requestStatus = false;

    // Now Set the request payload
    var sendData = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "SellerEmail": sellerEmailAddress,
    };

    // Our Chat Object That We want to Send Back To User
    Chat chat = Chat(0, "", "", "", "", "");

    // Send Request to Our Server
    await serverHelper.sendPostRequest(context, "initiate_chat", sendData,
        (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        requestStatus = true;

        var data = result['message'];

        // Now We Populate our Chat Information
        chat = Chat(
            data['chatID'],
            data['fullName'],
            "${serverHelper.host}/static/" + data['profilePicture'],
            data['lastMessage'],
            data['time'],
            data['count']);
      }

      // Display a Message on Screen
      displayHelper.displaySnackBar(result['message'], requestStatus, context);
    });

    return chat;
  }
}
