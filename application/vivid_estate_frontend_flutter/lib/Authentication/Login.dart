import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ForgotPassword.dart';
import 'package:vivid_estate_frontend_flutter/BuyerMain.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/SellerMain.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // Controllers to handle user Input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // User Class to Perform Different User Functions
  var user = User();

  // Perform the User Login
  void performLogin(BuildContext context, String email, String password) async {
    // Make a User Login Request
    if (await user.login(context, email, password)) {
      // Move to Home Page. Depends Upon User Type
      Navigator.pop(context);
      Navigator.pop(context);

      // Create a new Home Page
      var homePage =
          user.userType == "Buyer" ? const BuyerMain() : const SellerMain();

      // Move to the Home Page
      Navigator.push(
          context, MaterialPageRoute(builder: (myContext) => homePage));
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
                            controller: emailController,
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
                            controller: passwordController,
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
                          // Perform a Login request for the User
                          performLogin(context, emailController.text,
                              passwordController.text);
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
