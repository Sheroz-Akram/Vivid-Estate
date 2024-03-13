import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Login.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/SignUp.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
        ),
        actions: <Widget>[
          // Login Button
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xFF1EF1EE)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      // Rounded border
                      side: const BorderSide(
                          color: Color(0xFF0E0F33), width: 2.0), // Border style
                      borderRadius: BorderRadius.circular(4.0),
                    ))),
                onPressed: () {
                  // Move to Login Page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5006E86),
                      fontFamily: "Berlin Sans", // Use a standard font
                    ))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage(
                                      userType: "Buyer",
                                    )));
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

                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text("---------- OR ----------")),

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage(
                                      userType: "Seller",
                                    )));
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
    );
  }
}
