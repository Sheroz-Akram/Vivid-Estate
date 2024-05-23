import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/DisplayHelper.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Review.dart';

class Property {
  // Indentifier of the Property
  final propertyID;

  // Controller to Save Data
  Property({required this.propertyID});

  // Property Display Data
  var images = [];
  var imagesCount = 0;
  var propertyType = "";
  var listingType = "";

  // Property Information
  var description = "";
  var location = "";
  var price = 0;
  var size = 0;
  var beds = 0;
  var floors = 0;
  var views = 0;
  var likes = 0;

  // Seller Information
  var sellerPicture = "";
  var sellerName = "";
  var sellerEmail = "";
  var isFavourite = false;

  // Helper Classes
  var serverHelper = ServerInfo(); // Helps to Communicate with the Server
  var displayHelper = DisplayHelper(); // Helps to Display Messages on Screen

  // Get Complete Data Of the Property From Server
  Future<void> retriveCompletePropertyData(
      BuildContext context, String emailAddress, String privateKey) async {
    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID
    };

    // Now We Send The Request to the Server
    await serverHelper
        .sendPostRequest(context, "property_detail", requestPayload, (result) {
      // If We Got a success response from server
      if (result['status'] == "success") {
        // Now we Store the Data
        images = result['message']['Images'];
        imagesCount = result['message']['TotalImages'];
        listingType = result['message']['ListingType'];
        propertyType = result['message']['PropertyType'];
        description = result['message']['Description'];
        location = result['message']['Location'];
        price = result['message']['Price'];
        size = result['message']['Size'];
        beds = result['message']['Beds'];
        floors = result['message']['Floors'];
        views = result['message']['Views'];
        likes = result['message']['Likes'];
        sellerPicture = result['message']["SellerPicture"];
        sellerName = result['message']['SellerName'];
        sellerEmail = result['message']['SellerEmail'];
        isFavourite = result['message']['IsFavourite'];
      }

      print(result['message']['IsFavourite']);
    });
  }

  // Add a Property To Favourtite List
  Future<bool> addToFavourite(
      BuildContext context, String emailAddress, String privateKey) async {
    // Variable to Check Status Of Our Request
    var requestStatus = false;

    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID
    };

    // Send Request to Our Server
    await serverHelper
        .sendPostRequest(context, "add_to_favourite", requestPayload, (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        requestStatus = true;
      }

      // Display a Status Message to the User
      displayHelper.displaySnackBar(
          result['message'], result['status'] == "success", context);
    });

    return requestStatus;
  }

  // Remove A Property From The Favourite List
  Future<bool> removeFromFavourite(
      BuildContext context, String emailAddress, String privateKey) async {
    // Variable to Check Status Of Our Request
    var requestStatus = false;

    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID
    };

    // Send Request to Our Server
    await serverHelper.sendPostRequest(
        context, "remove_from_favourite", requestPayload, (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        requestStatus = true;
      }
    });

    return requestStatus;
  }

  // Get All Reviews Of the Property By Sending a Request to Server
  Future<List<Review>> retriveReviews(
      BuildContext context, String emailAddress, String privateKey) async {
    // List To Store Our Reviews
    List<Review> reviewList = [];

    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID
    };

    // Send Request to Our Server
    await serverHelper
        .sendPostRequest(context, "get_all_reviews", requestPayload, (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        // Loop Through All The reviews and Add to our List
        for (var i = 0; i < result['message']['ReviewsCount']; i++) {
          // Create a new Review Object
          var review = Review(
              reviewID: result['message']['Reviews'][i]['ReviewID'],
              personName: result['message']['Reviews'][i]['PersonName'],
              personImage: result['message']['Reviews'][i]['PersonImage'],
              reviewTime: result['message']['Reviews'][i]['ReviewTime'],
              reviewRating: result['message']['Reviews'][i]['ReviewRating'],
              reviewComment: result['message']['Reviews'][i]['ReviewComment']);

          // Store Our Review Into Review List
          reviewList.add(review);
        }
      }
    });

    return reviewList;
  }

  // Submit a review for the user
  Future<bool> submitReview(BuildContext context, String emailAddress,
      String privateKey, String comment, int rating) async {
    // Save the Status of Our Request
    var requestStatus = false;

    // Check Our Data Before Validating to the User
    if (comment.isEmpty) {
      displayHelper.displaySnackBar(
          "Please enter the review comment.", false, context);
      return false;
    }
    if (rating == 0) {
      displayHelper.displaySnackBar(
          "Please give a rating to the property", false, context);
      return false;
    }

    // Make A Payload to Send to the Server
    var requestPayload = {
      "Email": emailAddress,
      "PrivateKey": privateKey,
      "PropertyID": propertyID,
      "ReviewComment": comment,
      "ReviewRating": rating.toString()
    };

    print(requestPayload);

    // Send Request to Our Server
    await serverHelper.sendPostRequest(context, "submit_review", requestPayload,
        (result) {
      // Check the Status of Our Request
      if (result['status'] == "success") {
        requestStatus = true;
      }
      displayHelper.displaySnackBar(
          result['message'], result['status'] == "success", context);
    });

    return requestStatus;
  }
}
