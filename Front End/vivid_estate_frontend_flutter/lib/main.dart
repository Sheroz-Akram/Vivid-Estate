import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/second.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(children: <Widget>[
          // Application Logo
          Image.asset(
            "assets/logo.png",
            width: MediaQuery.of(context).size.width * 0.50,
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

          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
              child: const Text("Second"))
        ]),
      ),
    ));
  }
}
