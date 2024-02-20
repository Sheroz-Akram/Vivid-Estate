import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Login.dart';
import 'package:vivid_estate_frontend_flutter/OTP.dart';
import 'package:vivid_estate_frontend_flutter/SignUp.dart';
import 'package:vivid_estate_frontend_flutter/User.dart';
import 'package:vivid_estate_frontend_flutter/Welcome.dart';
import 'package:vivid_estate_frontend_flutter/cnic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivid Estate',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006E86)),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.pink, width: 4)))),
      home: const MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Main Data of our home page
        body: Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: Column(children: <Widget>[
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
          const Text("Development Page Testing V1.00",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5093A1),
                fontFamily: "Berlin Sans", // Use a standard font
              )),

          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              child: const Text("Welcome Page")),

          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignUpPage(userType: "Buyer")));
              },
              child: const Text("Sign Up")),

          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Login Page")),

          TextButton(
              onPressed: () {
                var userInfo = const User(
                    Name: "Sheroz Akram",
                    Email: "Sheroz.akram@outlook.com",
                    Username: "Sheroz@123",
                    Password: "abc@ABC",
                    Type: "Buyer");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTPPage(userInfo: userInfo)));
              },
              child: const Text("OTP Page")),

          TextButton(
              onPressed: () {
                var userInfo = const User(
                    Name: "Sheroz Akram",
                    Email: "Sheroz.akram@outlook.com",
                    Username: "Sheroz@123",
                    Password: "abc@ABC",
                    Type: "Buyer");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CnicPage(userInfo: userInfo)));
              },
              child: const Text("CNIC Page")),
        ]),
      ),
    ));
  }
}
