import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
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
                      child: const Column(
                        children: <Widget>[
                          Align(
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
                            decoration:
                                InputDecoration(hintText: "Example Name"),
                          ),
                        ],
                      ),
                    ),

                    // Enter Email Address
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Column(
                        children: <Widget>[
                          Align(
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
                            decoration: InputDecoration(
                                hintText: "example@example.com"),
                          ),
                        ],
                      ),
                    ),

                    // Enter User Name
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Column(
                        children: <Widget>[
                          Align(
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
                            decoration: InputDecoration(hintText: "User123"),
                          ),
                        ],
                      ),
                    ),

                    // Enter User Password
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Column(
                        children: <Widget>[
                          Align(
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
                            decoration: InputDecoration(
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

                          // To be Implemented
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
                                style: TextStyle(color: Color(0xFF006E86)),
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
                                      color: Color.fromARGB(255, 224, 0, 0)),
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
    );
  }
}
