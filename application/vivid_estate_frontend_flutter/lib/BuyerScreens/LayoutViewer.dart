import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

// ignore: must_be_immutable
class LayoutViewer extends StatefulWidget {
  LayoutViewer({super.key, required this.Layouts});

  // Layout Data of the Property
  dynamic Layouts;

  @override
  State<LayoutViewer> createState() => _LayoutViewer();
}

/// Display The Preview of the Property
class _LayoutViewer extends State<LayoutViewer> {
  // Store The Current Index of the Layout
  int index = 0;

  // Server Helper to Communicate with Server
  var server = ServerInfo();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Display Top Header
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0XFF006E86))),
                const Text(
                  "Property Layouts",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Color(0XFF006E86)),
                ),
                const Spacer(),
              ],
            ),

            // Display Image Here
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Image.network(
                "${server.host}/static/${widget.Layouts[index]['FileLocation']}",
                fit: BoxFit.fitHeight,
              ),
            ),

            // Bottom Navigation
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                  // Navigation Title
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Change Floor",
                      style: TextStyle(
                          color: Color(0XFF5F5F5F),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Navigation Control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Back Button
                      IconButton(
                          onPressed: () {
                            if (index == 0) {
                              setState(() {
                                index = widget.Layouts.length - 1;
                              });
                            } else {
                              setState(() {
                                index--;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0XFF5F5F5F),
                          )),
                      // Current Floor Text
                      Text(
                        widget.Layouts[index]['FloorName'],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 136, 136, 136),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      // Back Button
                      IconButton(
                          onPressed: () {
                            if (index == widget.Layouts.length - 1) {
                              setState(() {
                                index = 0;
                              });
                            } else {
                              setState(() {
                                index++;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0XFF5F5F5F),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
