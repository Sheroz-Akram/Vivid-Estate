import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Welcome.dart';

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

// Display Logout Option
Future<bool?> showLogoutDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // User must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do You want to logout from the current account?"),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false for 'No'
            },
          ),
          ElevatedButton(
            child: const Text('Yes'),
            onPressed: () {
              logoutUser(context);
              Navigator.of(context).pop(true); // Return true for 'Yes'
            },
          ),
        ],
      );
    },
  );
}

// Function to Scroll to the Bottom of the Page
void scrollToBottom(scrollController) {
  Timer(const Duration(seconds: 1), () {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500), // Adjust animation duration
      curve: Curves.easeOut, // Adjust animation curve
    );
  });
}

// Display a Snack Bar on the User Screen
void displaySnackBar(BuildContext context, String message) {
  // Display the Snack Bar
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Box Shadow for the Widgets
List<BoxShadow> getBoxShadow() {
  return const [
    BoxShadow(
      color: Color.fromARGB(255, 107, 107, 107), // Set shadow color to black
      blurRadius: 4.0, // Adjust blur for softness
      spreadRadius: 1.0, // Adjust spread for size
      offset: Offset(0.0, 0.0), // Offset the shadow
    ),
  ];
}
