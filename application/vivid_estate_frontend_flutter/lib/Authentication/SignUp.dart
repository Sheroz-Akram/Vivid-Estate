import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:vivid_estate_frontend_flutter/Authentication/Login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/OTP.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.userType});
  final String userType;

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _full_name_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _user_name_controller = TextEditingController();
  final _password_controller = TextEditingController();
  var userExit = true;

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
  void sendSignUpRequest(
      fullName, email, username, password, userType, myContext) async {
    EasyLoading.instance
      ..userInteractions = false
      ..loadingStyle = EasyLoadingStyle.dark;

    setState(() {
      userExit = false;
    });
    EasyLoading.show(
      status: "Loading...",
    );

    // Get the User Location Data
    var user = User();
    await user.getCityLocation(myContext);
    var lang = user.langitude.toString();
    var long = user.longitude.toString();

    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/signup");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'FullName': fullName,
        'Email': email,
        'User': username,
        'Password': password,
        'Type': userType,
        'Latitude': lang,
        'Longitude': long
      });

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
          var userInfo = User();
          userInfo.fullName = fullName;
          userInfo.emailAddress = email;
          userInfo.username = username;
          userInfo.password = password;
          userInfo.userType = userType;

          // Move to the OTP Page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (myContext) => OTPPage(userInfo: userInfo)));
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
  void createAccount(BuildContext context) {
    // Check Email is Valid or Not
    if (_email_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter an Email Address.")));
    }
    if (!isEmailValid(_email_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Entered email is invalid.")));
    } else if (_full_name_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your full name")));
    } else if (_user_name_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter user name")));
    } else if (_user_name_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter user name")));
    } else if (_password_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter password.")));
    } else if (!isPasswordStrong(_password_controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password is weak. Enter Strong Password")));
    }

    // Clear All the checks
    // Now send request to the server
    else {
      // Send the Request
      sendSignUpRequest(
          _full_name_controller.text,
          _email_controller.text,
          _user_name_controller.text,
          _password_controller.text,
          widget.userType,
          context);
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
              Center(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      // Application Name
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text("Sign Up",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006E86),
                              fontFamily: "Berlin Sans", // Use a standard font
                            )),
                      ),

                      Image.asset(
                        "assets/UI/signUpImage.png",
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
                      // Enter Full Name
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Enter Full Name",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _full_name_controller,
                              decoration: const InputDecoration(
                                  hintText: "Example Name"),
                            ),
                          ],
                        ),
                      ),

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

                      // Enter User Name
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Enter Username",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _user_name_controller,
                              decoration:
                                  const InputDecoration(hintText: "User123"),
                            ),
                          ],
                        ),
                      ),

                      // Enter User Password
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

                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: const Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF006E86)),
                            "Creating a account means you are okay with our terms of service and privacy policy"),
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
                            createAccount(context);
                          },
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(10),
                            child: const Text("Sign Up",
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
                                  "Already have a account?"),
                              TextButton(
                                onPressed: () {
                                  // Move to Login Page

                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: const Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 224, 0, 0),
                                        fontSize: 18.0),
                                    "Login"),
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
      ),
    );
  }
}
