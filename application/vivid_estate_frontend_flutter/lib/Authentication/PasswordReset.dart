import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Congrats.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.Email, required this.Password});
  final String Email;
  final String Password;
  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  final _password_controller = TextEditingController();
  final _confirm_password_controller = TextEditingController();

  var userExit = true;

  /*
  Send Password Reset Request to the Server
  */
  void passwordResetRequest(password, confirmPassword, myContext) async {
    EasyLoading.instance
      ..userInteractions = false
      ..loadingStyle = EasyLoadingStyle.dark;

    setState(() {
      userExit = false;
    });
    EasyLoading.show(
      status: "Loading...",
    );

    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/reset_password");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': widget.Email,
        'Password': widget.Password,
        'NewPassword': password,
      });

      setState(() {
        userExit = true;
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          // Show Success Message
          EasyLoading.showSuccess(result['message']);

          // Password Reset Successfull
          Navigator.push(
              myContext,
              MaterialPageRoute(
                  builder: (myContext) => const CongratulationsPage(
                      title: "Your Password is reset!",
                      message:
                          "Please continue and login to your account with your email and new password. Thanks!",
                      noBacks: 4)));
        }
        // Error in request
        else {
          setState(() {
            userExit = true;
          });
          EasyLoading.showError(result['message']);
        }
      } else {
        setState(() {
          userExit = true;
        });
        throw Exception('Failed to load data');
      }
    }

    // Error Connecting to Server
    catch (e) {
      setState(() {
        userExit = true;
      });
      EasyLoading.showError('Failed to connect to the server: $e');
    }
  }

  // Make Sure Password is Strong
  bool isPasswordStrong(String password) {
    // Length Requirement
    if (password.length < 8) {
      return false;
    }

    // Capital Letter Requirement
    bool hasCapital = false;
    for (int i = 0; i < password.length; i++) {
      if (password.codeUnitAt(i) >= 65 && password.codeUnitAt(i) <= 90) {
        hasCapital = true;
        break;
      }
    }

    return hasCapital;
  }

  /*
  Validate the input data and send request
  */
  void submitPasswordData(BuildContext context) {
    // Check Email is Valid or Not
    if (_password_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Enter Card Holder Name")));
    } else if (!isPasswordStrong(_password_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password is weak. Enter Strong Password")));
    } else if (_password_controller.text != _confirm_password_controller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter as password for confirmation")));
    }

    // Clear All the checks
    // Now send request to the server
    else {
      // Send the Request
      passwordResetRequest(_password_controller.text,
          _confirm_password_controller.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: userExit,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5093A1),
                  fontFamily: "Berlin Sans", // Use a standard font
                )),
            leading: IconButton(
              icon: Image.asset(
                "assets/UI/backButtonImage.png",
                height: 50,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Page Info
              Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 50, right: 50, bottom: 20),
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/UI/resetPasswordImage.png", width: 150),

                    // Page Information
                    const Text("Reset Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006E86),
                          fontFamily: "Berlin Sans", // Use a standard font
                        )),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF006E86)),
                        "Please enter your new password that you want to set as your account password."),
                  ],
                ),
              ),

              // Edit User Info
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      // Enter New Password
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Enter new password",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              obscureText: true,
                              controller: _password_controller,
                              decoration: const InputDecoration(
                                  hintText: "8+ Characters, 1 Capital"),
                            ),
                          ],
                        ),
                      ),

                      // Confirm new Password
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Confirm Password",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              obscureText: true,
                              controller: _confirm_password_controller,
                              decoration: const InputDecoration(
                                  hintText: "same as above"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFF146479)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  // Rounded border
                                  side: const BorderSide(
                                      color: Color(0xFF0E0F33),
                                      width: 2.0), // Border style
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {
                              // Now Send the Password Reset Request
                              submitPasswordData(context);
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(10),
                              child: const Text("Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
