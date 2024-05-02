import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

class Buyer extends User {
  // Get the Complete Detail of the Property
  dynamic getPropertyDetail(BuildContext userContext, String propertyID) async {
    // Prepare our Post Request Data Body
    var requestBody = {"PropertyID": propertyID};

    // Data That We want to return
    dynamic PropertyData = {
      "Images": [],
      "ImagesCount": 0,
      "PropertyType": "",
      "ListingType": "",
      "Description": "",
      "Location": "",
      "Price": 0,
      "Size": 0,
      "Beds": 0,
      "Floors": 0,
      "Views": 0,
      "Likes": 0,
      "SellerPicture": "",
      "SellerName": "",
      "SellerEmail": ""
    };

    // Send a Request to the Server
    await server.sendPostRequest(userContext, "property_detail", requestBody,
        (result) {
      // We get a successfull response
      if (result['status'] == "success") {
        // Now we Store the Data
        PropertyData['Images'] = result['message']['Images'];
        PropertyData['ImagesCount'] = result['message']['TotalImages'];
        PropertyData['ListingType'] = result['message']['ListingType'];
        PropertyData['PropertyType'] = result['message']['PropertyType'];
        PropertyData['Description'] = result['message']['Description'];
        PropertyData['Location'] = result['message']['Location'];
        PropertyData['Price'] = result['message']['Price'];
        PropertyData['Size'] = result['message']['Size'];
        PropertyData['Beds'] = result['message']['Beds'];
        PropertyData['Floors'] = result['message']['Floors'];
        PropertyData['Views'] = result['message']['Views'];
        PropertyData['Likes'] = result['message']['Likes'];
        PropertyData['SellerPicture'] = result['message']["SellerPicture"];
        PropertyData['SellerName'] = result['message']['SellerName'];
        PropertyData['SellerEmail'] = result['message']['SellerEmail'];
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });

    return PropertyData;
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
    await server.sendPostRequest(
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
    await server.sendPostRequest(
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
}
