import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PostView.dart';

class ReplyBidMessage extends StatefulWidget {
  const ReplyBidMessage({super.key, required this.message, required this.time});
  final String message;
  final String time;
  @override
  State<ReplyBidMessage> createState() => _ReplyBidMessage();
}

class _ReplyBidMessage extends State<ReplyBidMessage> {
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
                                    const Color.fromARGB(255, 160, 160, 160),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                              ),
                              child: const Text(
                                "View",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            message,
                            style: const TextStyle(fontSize: 18),
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
