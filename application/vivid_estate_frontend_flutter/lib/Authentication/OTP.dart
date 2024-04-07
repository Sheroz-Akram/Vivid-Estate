import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/cnic.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.userInfo});

  final User userInfo;

  @override
  State<OTPPage> createState() => _OTPPage();
}

class _OTPPage extends State<OTPPage> {
  final _entered_otp = TextEditingController();
  var canBack = true;

  /*

  Send a POST request to the Server

  */
  void sendSignUpRequest(email, otp, type, myContext) async {
    EasyLoading.instance
      ..userInteractions = false
      ..loadingStyle = EasyLoadingStyle.dark;

    EasyLoading.show(status: "Verifying...");

    // User can't move back
    setState(() {
      canBack = false;
    });

    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/otp_verify");
    try {
      // Our Request
      var response = await http
          .post(url, body: {'Email': email, 'OTP': otp, "Type": type});

      // Allow User to move back
      setState(() {
        canBack = true;
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        EasyLoading.showSuccess(response.body.toString());
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          EasyLoading.showSuccess(result['message']);

          // Move to the CNIC Page
          Navigator.push(
              myContext,
              MaterialPageRoute(
                  builder: (myContext) => CnicPage(userInfo: widget.userInfo)));
        }
        // Error in request
        else {
          EasyLoading.showError(result['message']);
        }
      } else {
        throw Exception('Failed to load data');
      }
    }

    // Error Connecting to Server
    catch (e) {
      // Allow User to move back
      setState(() {
        canBack = true;
      });
      EasyLoading.showError('Failed to connect to the server: $e');
    }
  }

  /*

  Send a Request to the Server


  */
  void resendOTP(myContext) async {
    EasyLoading.instance
      ..userInteractions = false
      ..loadingStyle = EasyLoadingStyle.dark;

    setState(() {
      canBack = false;
    });
    EasyLoading.show(
      status: "Loading...",
    );

    // URL to Send Request
    var host = ServerInfo().host;
    var url = Uri.parse("$host/resend_otp");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': widget.userInfo.emailAddress,
        'Password': widget.userInfo.password,
      });

      setState(() {
        canBack = true;
      });

      // Get a Response from the Server
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        // Valid Request
        if (result['status'] == "success") {
          // Show Success Message
          EasyLoading.showSuccess(result['message']);
        }
        // Error in request
        else {
          EasyLoading.showError(result['message']);
        }
      } else {
        // Allow User to move back
        setState(() {
          canBack = true;
        });
        throw Exception('Failed to load data');
      }
    }

    // Error Connecting to Server
    catch (e) {
      // Allow User to move back
      setState(() {
        canBack = true;
      });
      EasyLoading.showError('Failed to connect to the server: $e');
    }
  }

  // Verify OTP with the Server
  void verifyOTPRequest(BuildContext myContext) {
    // Get Our OTP
    var otp = _entered_otp.text;

    // Check if Value if 4
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter 4 Digits OTP")));
    }

    // OTP is verified now send to the Server
    else {
      sendSignUpRequest(widget.userInfo.emailAddress, otp,
          widget.userInfo.userType, myContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canBack,
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

          // Page Body
          body: Column(
            children: <Widget>[
              // Page Information
              Container(
                margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/UI/otpImage.png", width: 150),

                    // Page Information
                    const Text("Verify Email",
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
                        "We have send you One Time Password (OTP) to your email address. Please verify"),
                  ],
                ),
              ),

              // OTP Entry Box
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  width: 300,
                  child: PinCodeTextField(
                    appContext: context, // Required for auto-focus
                    controller: _entered_otp,
                    length: 4, // Number of OTP digits
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldWidth: 50,
                        fieldHeight: 50,
                        activeFillColor: Colors.white,
                        inactiveFillColor:
                            const Color.fromARGB(255, 29, 5, 170),
                        selectedFillColor: const Color(0xFF006E86),
                        inactiveColor: Colors.grey),
                    onChanged: (value) {
                      // Perform Opertaion When Output is 4
                      if (value.length == 4) {
                        verifyOTPRequest(context);
                      }
                    },
                  ),
                ),
              ),

              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xFF146479)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        // Rounded border
                        side: const BorderSide(
                            color: Color(0xFF0E0F33),
                            width: 2.0), // Border style
                        borderRadius: BorderRadius.circular(4.0),
                      ))),
                  onPressed: () {
                    // Verify the OTP
                    verifyOTPRequest(context);
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    child: const Text("Verify",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Berlin Sans", // Use a standard font
                        )),
                  )),

              /*
      
              More Information about OTP and Link To Resend OTP
      
              */
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF006E86)),
                          "Didn't receive the OTP?"),
                      TextButton(
                        onPressed: () {
                          // Resend the OTP
                          resendOTP(context);
                        },
                        child: const Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 224, 0, 0)),
                            "Resend"),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
