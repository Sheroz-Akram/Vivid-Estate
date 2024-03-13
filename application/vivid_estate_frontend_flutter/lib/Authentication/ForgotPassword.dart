import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/PasswordResetOTP.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
  });
  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final _email_controller = TextEditingController();

  var userExit = true;

  /*
  Send Password Reset Request to the Server
  */
  void passwordResetRequest(email, myContext) async {
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
    var url = Uri.parse("$host/forgot_password");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': email,
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

          // Password Reset OTP is Send. Now Move to OTP Page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PasswordResetOTP(userEmailAddress: email)));
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

  // Validate Email Address
  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  /*
  Validate the input data and send request
  */
  void submitEmailData(BuildContext context) {
    // Check Email is Valid or Not
    if (_email_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Enter Card Holder Name")));
    } else if (!isEmailValid(_email_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Entered email is invalid! Check email")));
    }

    // Clear All the checks
    // Now send request to the server
    else {
      // Send the Request
      passwordResetRequest(_email_controller.text, context);
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
                    Image.asset("assets/UI/forgotPasswordImage.png",
                        width: 150),

                    // Page Information
                    const Text("Forgot Password?",
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
                        "Don't worry we will help you to reset your password. Please provide your email address."),
                  ],
                ),
              ),

              // Edit User Info
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      // Enter Email Address
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Enter Email Address",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _email_controller,
                              decoration: const InputDecoration(
                                  hintText: "example@example.com"),
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
                              submitEmailData(context);
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(10),
                              child: const Text("Send OTP",
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
