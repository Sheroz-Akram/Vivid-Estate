import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Top Bar
            Container(
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
                  ),
                  const Spacer(),

                  // Login Button
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xFF1EF1EE)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            // Rounded border
                            side: const BorderSide(
                                color: Color(0xFF0E0F33),
                                width: 2.0), // Border style
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        // Move to Login Page
                      },
                      child: const Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5006E86),
                            fontFamily: "Berlin Sans", // Use a standard font
                          )))
                ],
              ),
            ),

            // Vivid Estate Data
            Column(children: <Widget>[
              // Application Logo
              Image.asset(
                "assets/logo.png",
                width: 200,
              ),

              // Application Name
              const Text("Vivid Estate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006E86),
                    fontFamily: "Berlin Sans", // Use a standard font
                  )),

              // Application Text
              const Text("Your Path to Real Residence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5093A1),
                    fontFamily: "Berlin Sans", // Use a standard font
                  )),
            ]),

            // Sign Up Links
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  color: Color(0xFFBBE4EC),
                  border: Border(
                      top: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  )),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text("Welcome Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006E86),
                          fontFamily: "Berlin Sans", // Use a standard font
                        )),
                  ),

                  // Buyer Sign Up Button
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xFF1EF1EE)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            // Rounded border
                            side: const BorderSide(
                                color: Color(0xFF0E0F33),
                                width: 2.0), // Border style
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        // Move to Buyer Sign Up Page
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(5),
                        child: const Text("Find a Property",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5006E86),
                              fontFamily: "Berlin Sans", // Use a standard font
                            )),
                      )),

                  const Text("---------- OR ----------"),

                  // Sell Or Rent Property
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xFF146479)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            // Rounded border
                            side: const BorderSide(
                                color: Color(0xFF0E0F33),
                                width: 2.0), // Border style
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        // Move to Seller Sign Up Page
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(5),
                        child: const Text("Sell or Rent Property",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "Berlin Sans", // Use a standard font
                            )),
                      )),

                  Center(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Image.asset(
                        "assets/UI/welcomeBottomImage.png",
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
