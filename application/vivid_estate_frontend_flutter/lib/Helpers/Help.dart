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
