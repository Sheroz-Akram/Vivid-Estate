import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ForgotPassword.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerMain.dart';
import 'package:vivid_estate_frontend_flutter/SellerMain.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // Controllers to handle user Input
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  var userExit = true;

  // Store the User Login Information
  void storeUserLoginData(String userEmail, String privateKey, String userType,
      BuildContext myContext) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", true);
    prefs.setString("userEmail", userEmail);
    prefs.setString("privateKey", privateKey);
    prefs.setString("userType", userType);

    // Move to the Next Page. Depending Upon User Type
    Navigator.pop(myContext);
    if (userType == "Buyer") {
      Navigator.push(
          myContext, MaterialPageRoute(builder: (myContext) => BuyerMain()));
    } else {
      Navigator.push(
          myContext, MaterialPageRoute(builder: (myContext) => SellerMain()));
    }
  }

  // Validate Email Address
  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
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

  Send a Request to the Server


  */
  void sendLoginRequest(email, password, myContext) async {
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
    var url = Uri.parse("$host/login");
    try {
      // Our Request
      var response =
          await http.post(url, body: {'Email': email, 'Password': password});

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          // Show Success Message
          setState(() {
            userExit = true;
          });
          EasyLoading.showSuccess(result['message']);

          // Store User Information
          storeUserLoginData(
              email, result['privateKey'], result['userType'], myContext);
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

  /*

  Validate the input data and send request

  */
  void submitLoginData(BuildContext myContext) {
    // Check Email is Valid or Not
    if (!isEmailValid(_email_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Entered email is invalid! Check email")));
    } else if (!isPasswordStrong(_password_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password is weak. Enter Strong Password")));
    }

    // Clear All the checks
    // Now send request to the server
    else {
      // Send the Request
      sendLoginRequest(
          _email_controller.text, _password_controller.text, myContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Container(
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    // Application Name
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Text("Login",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006E86),
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                    ),

                    Image.asset(
                      "assets/UI/loginImage.png",
                      width: 150,
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Sign Up Form
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

                    // Enter Password
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Enter Password",
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

                    TextButton(
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
                          // Create a new Account
                          submitLoginData(context);
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(10),
                          child: const Text("Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily:
                                    "Berlin Sans", // Use a standard font
                              )),
                        )),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF006E86), fontSize: 18.0),
                                "Forgot Password?"),
                            TextButton(
                              onPressed: () {
                                // Move to the Password Reset Page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()));
                              },
                              child: const Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 224, 0, 0),
                                      fontSize: 18.0),
                                  "Reset"),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
