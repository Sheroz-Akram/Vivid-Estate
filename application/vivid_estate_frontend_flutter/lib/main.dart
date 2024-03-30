import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/Welcome.dart';
import 'package:vivid_estate_frontend_flutter/BuyerMain.dart';
import 'package:vivid_estate_frontend_flutter/Classes/User.dart';
import 'package:vivid_estate_frontend_flutter/SellerMain.dart';

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
      debugShowCheckedModeBanner: false,
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
  void initState() {
    super.initState();
    loadHomePage(context);
  }

  // Add Delay of 2 Seconds
  Future<void> delayTime() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Loading the Application depending upon user login status
  void loadHomePage(BuildContext myContext) async {
    // Get the User Data
    var user = User();
    var userAuthData = await user.getAuthData();

    // Move to the Next Page. Depending Upon User Type
    await delayTime();

    // Now we move the user to its destinated screen
    if (userAuthData == true) {
      if (user.userType == "Buyer") {
        Navigator.pushReplacement(myContext,
            MaterialPageRoute(builder: (myContext) => const BuyerMain()));
      } else {
        Navigator.pushReplacement(myContext,
            MaterialPageRoute(builder: (myContext) => const SellerMain()));
      }
    } else {
      // If User not Login then move to Welcome Page
      Navigator.pushReplacement(myContext,
          MaterialPageRoute(builder: (myContext) => const WelcomePage()));
    }
  }

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

          // Loading Gif File
          Image.asset(
            "assets/UI/loading.gif",
            width: 200,
          ),
        ]),
      ),
    ));
  }
}
