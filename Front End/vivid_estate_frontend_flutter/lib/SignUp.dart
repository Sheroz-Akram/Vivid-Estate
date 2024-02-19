import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Top Back Buttton
          Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    // Move to Previous Screen
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/UI/backButtonImage.png",
                        height: 50,
                      ),
                      const Text("Back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5093A1),
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  // Application Name
                  Container(
                    margin: EdgeInsets.only(right: 10),
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
          Column(
            children: <Widget>[
              TextField(
                style: TextField.materialMisspelledTextStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}
