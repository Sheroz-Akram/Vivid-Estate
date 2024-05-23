import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DisplayHelper {
  // Varaiables
  var canUserBack =
      true; // Store if the User can back to the previous screen or not

  // Display A Snack Bar to the User. Also Show Success and Error
  void displaySnackBar(String message, bool status, BuildContext context) {
    // Code to Display the Snack Bar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(

        // Check if the Message is Success or Error
        content: status == true
            ? Text("Success: $message")
            : Text("Error: $message")));
  }

  // Display Loading Bar On Screen
  void displayLoadingbar() {
    // Set the Parameters
    EasyLoading.instance
      ..userInteractions = false
      ..loadingStyle = EasyLoadingStyle.dark;

    // Show Loading Bar
    EasyLoading.show(
      status: "Loading...",
    );

    // User can't back to previous screen
    canUserBack = false;
  }

  // Stop the Loading Bar. Display Message with Error or Success
  void stopLoadingBar(bool status) {
    // Display Success Message
    if (status) {
      EasyLoading.showSuccess("Success");
    }
    // Display Error Message
    else {
      EasyLoading.showError("Error");
    }

    // User can back to previous screen
    canUserBack = true;
  }

  // Convert Numbers to English Suffixes
  String formatNumber(int num) {
    if (num < 1000) {
      return num.toString();
    } else if (num < 1000000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    } else if (num < 1000000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(num / 1000000000).toStringAsFixed(1)}B';
    }
  }
}
