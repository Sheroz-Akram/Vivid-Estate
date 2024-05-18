import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';

class ReplyFileMessage extends StatefulWidget {
  const ReplyFileMessage(
      {super.key,
      required this.message,
      required this.time,
      required this.status});
  final String message;
  final String time;
  final String status;
  @override
  State<ReplyFileMessage> createState() => _ReplyFileMessage();
}

class _ReplyFileMessage extends State<ReplyFileMessage> {
  // Variables to Store the Files Data
  var fileName;
  var fileLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Prase Json Data
    Map<String, dynamic> json = jsonDecode(widget.message);

    // Store the Json Data into Location
    setState(() {
      fileLocation = json['fileLocation'];
      fileName = json['fileName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 60, top: 5, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          fileName,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            // Download the file
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 160, 160, 160),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                          ),
                          child: const Text(
                            "Download",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                  height: 20,
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    widget.time,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
