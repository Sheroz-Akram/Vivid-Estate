import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PostView.dart';

class SendBidMessage extends StatefulWidget {
  const SendBidMessage(
      {super.key,
      required this.message,
      required this.time,
      required this.status});
  final String message;
  final String time;
  final String status;
  @override
  State<SendBidMessage> createState() => _SendBidMessage();
}

class _SendBidMessage extends State<SendBidMessage> {
  // Store the Bid Information
  var bidID;
  var propertyID;
  var propertyPicture;
  var bidAmount;
  var message;

  // Object to Comunicate with Sever
  var server = ServerInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Prase Json Data
    Map<String, dynamic> json = jsonDecode(widget.message);

    print(json);

    // Store the Json Data into Location
    setState(() {
      bidID = json['BidID'];
      propertyID = json['PropertyID'];
      propertyPicture = json['PropertyPicture'];
      bidAmount = json['BidAmount'];
      message = json['Message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            color: const Color(0xFF006E86),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image Widget to Display The Image Of Property
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.network(
                          "${server.host}/static/$propertyPicture",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 60, top: 5, bottom: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,

                            /**
                       * 
                       * Button to Open the Property Page
                       * 
                       */
                            child: ElevatedButton(
                              onPressed: () {
                                // Now Start Downloading the File
                                try {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostView(
                                              PropertyID:
                                                  propertyID.toString())));
                                } catch (e) {
                                  print(e);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 128, 155),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                              ),
                              child: const Text(
                                "View",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            message,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 5,
                  height: 20,
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        widget.time,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white54),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        widget.status.toLowerCase() == "viewed"
                            ? Icons.done_all
                            : Icons.done,
                        size: 20,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
