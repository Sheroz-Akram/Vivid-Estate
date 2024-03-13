import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage(
      {super.key,
      required this.title,
      required this.message,
      required this.noBacks});
  final String title;
  final String message;
  final int noBacks;
  @override
  State<CongratulationsPage> createState() => _CongratulationsPage();
}

class _CongratulationsPage extends State<CongratulationsPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Congratualtions Page
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: Row(children: <Widget>[
                    const Text("Congratulations",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006E86),
                          fontFamily: "Berlin Sans", // Use a standard font
                        )),
                    Image.asset(
                      "assets/UI/clapping.png",
                      height: 50,
                    )
                  ])),

              // Now Display the congratulations image
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  "assets/UI/congratsParty.png",
                  width: MediaQuery.sizeOf(context).width * 0.5,
                ),
              ),

              // Now Display the Title
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(widget.title,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006E86),
                      fontFamily: "Berlin Sans", // Use a standard font
                    )),
              ),

              // Now Display the Message
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF006E86)),
                    widget.message),
              ),

              // Our Continue Button
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
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
                      // Move Back to Home Page
                      for (int i = 0; i < widget.noBacks; i++) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      child: const Text("Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
