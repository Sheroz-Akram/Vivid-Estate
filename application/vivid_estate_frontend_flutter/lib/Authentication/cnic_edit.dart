import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Congrats.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';

class CnicEdit extends StatefulWidget {
  const CnicEdit({super.key, required this.userInfo});
  final User userInfo;

  @override
  State<CnicEdit> createState() => _CnicEdit();
}

class _CnicEdit extends State<CnicEdit> {
  final _cnic_name_controller = TextEditingController();
  final _cnic_number = TextEditingController();
  final _cnic_father_name = TextEditingController();
  final _cnic_dob = TextEditingController();

  var userExit = true;

  // Set the Field Values
  @override
  void initState() {
    super.initState();
    _cnic_name_controller.text = widget.userInfo.cnic_name;
    _cnic_number.text = widget.userInfo.cnicNumber;
    _cnic_father_name.text = widget.userInfo.fathername;
    _cnic_dob.text = widget.userInfo.dob;
  }

  /*
  Confirm the CNIC Data
  */
  void storeCNICData(name, father, cnicNumber, dob, myContext) async {
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
    var url = Uri.parse("$host/store_cnic");
    try {
      // Our Request
      var response = await http.post(url, body: {
        'Email': widget.userInfo.emailAddress,
        'Password': widget.userInfo.password,
        'cnicName': name,
        "cnicFather": father,
        'cnicNumber': cnicNumber,
        'cnicDob': dob
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

          // Account Creation successfull
          Navigator.push(
              myContext,
              MaterialPageRoute(
                  builder: (myContext) => const CongratulationsPage(
                      title: "Your Account is Created!",
                      message:
                          "Please continue and wait for your account verification. We will email you when your account verified then login. Thanks!",
                      noBacks: 5)));
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
  void submitCNICData(BuildContext context) {
    // Check Email is Valid or Not
    if (_cnic_name_controller.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Enter Card Holder Name")));
    } else if (_cnic_father_name.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Enter Father Name")));
    } else if (_cnic_number.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter CNIC Number")));
    } else if (_cnic_dob.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your dater of Birth")));
    }

    // Clear All the checks
    // Now send request to the server
    else {
      // Send the Request
      storeCNICData(_cnic_name_controller.text, _cnic_father_name.text,
          _cnic_number.text, _cnic_dob.text, context);
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
                    Image.asset("assets/UI/cnicEditImage.png", width: 150),

                    // Page Information
                    const Text("Verify Details",
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
                        "Please verify the CNIC details with the scanned data and change if you want"),
                  ],
                ),
              ),

              // Edit CNIC Data
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      // Enter CNIC Name
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Card Holder Name",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _cnic_name_controller,
                              decoration: const InputDecoration(
                                  hintText: "Example Name"),
                            ),
                          ],
                        ),
                      ),

                      // Enter CNIC Number
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("CNIC Number",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _cnic_number,
                              decoration: const InputDecoration(
                                  hintText: "example@example.com"),
                            ),
                          ],
                        ),
                      ),

                      // Enter Father Name
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Father Name",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _cnic_father_name,
                              decoration:
                                  const InputDecoration(hintText: "User123"),
                            ),
                          ],
                        ),
                      ),

                      // Enter Date of Birth
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Date of Birth",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5093A1),
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            ),
                            TextField(
                              controller: _cnic_dob,
                              decoration: const InputDecoration(
                                  hintText: "8+ Characters, 1 Capital"),
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
                              // Send the CNIC Data
                              submitCNICData(context);
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(10),
                              child: const Text("Complete",
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
