import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PostView.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/BiddingList.dart';

// ignore: must_be_immutable
class SellerAdPreview extends StatefulWidget {
  SellerAdPreview(
      {super.key,
      required this.PropertyID,
      required this.ImageLocation,
      required this.Price,
      required this.Location,
      required this.TimeAgo,
      required this.Views,
      required this.Likes,
      required this.BiddingData,
      required this.onCrossPressed,
      required this.onEditPressed});

  // Variables For Our Views
  int PropertyID;
  String ImageLocation;
  String Price;
  String Location;
  int TimeAgo;
  String Views;
  String Likes;
  dynamic BiddingData;
  final Function onCrossPressed;
  final Function onEditPressed;

  @override
  State<SellerAdPreview> createState() => _SellerAdPreview();
}

class _SellerAdPreview extends State<SellerAdPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          InkWell(
            // When the User Click On Property List
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostView(
                            PropertyID: widget.PropertyID.toString(),
                          )));
            },
            // Display our Property on the Favorite List
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Color(0XFFE2E2E2),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(
                          255, 207, 207, 207), // Set shadow color to black
                      blurRadius: 4.0, // Adjust blur for softness
                      spreadRadius: 1.0, // Adjust spread for size
                      offset: Offset(0.0, 0.0), // Offset the shadow
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Row(
                children: [
                  // Place the Image Of Our Property
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.5) - 40,
                    height: 150,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(10)),
                      child:
                          // Image Widget to Display The Image Of Property
                          Image.network(
                        widget.ImageLocation,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // Display The Information Of the Property
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.5) - 50,
                    margin: const EdgeInsets.only(left: 10),
                    height: 150,
                    child: Column(
                      children: [
                        // Favourite Property Title Information
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Text("RS ${(widget.Price)}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 59, 59, 59))),
                              const Spacer(),
                              // Remove Property Button
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: InkWell(
                                    onTap: () {
                                      // Remove the Property From Favourite List
                                      widget.onCrossPressed(widget.PropertyID);
                                    },
                                    child: const Icon(Icons.close)),
                              )
                            ],
                          ),
                        ),

                        // Give Space Between
                        const Spacer(),

                        // Display Other Information

                        // Display Location
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.Location,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5F5F5F))),
                        ),

                        // Give Space Between
                        const Spacer(),

                        // Display Time
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("${widget.TimeAgo} days ago",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5F5F5F))),
                        ),

                        const Spacer(),

                        // Display The Stats of our Favourite Property
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              // Display Views
                              Row(children: [
                                const Icon(Icons.remove_red_eye),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(widget.Views,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5F5F5F)))
                              ]),

                              const SizedBox(
                                width: 20,
                              ),

                              // Display Hearts
                              Row(
                                children: [
                                  const Icon(Icons.favorite),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(widget.Likes,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5F5F5F)))
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Property Options
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.5) - 40,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFF146479)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          // Rounded border
                          side: const BorderSide(
                              color: Color(0xFF0E0F33),
                              width: 2.0), // Border style
                          borderRadius: BorderRadius.circular(0.0),
                        ))),
                    onPressed: () {
                      // Open Edit Page
                      widget.onEditPressed(widget.PropertyID);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text("Edit Property",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                    )),
              ),

              // Display The List of Bids
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.5) - 40,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFF146479)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          // Rounded border
                          side: const BorderSide(
                              color: Color(0xFF0E0F33),
                              width: 2.0), // Border style
                          borderRadius: BorderRadius.circular(0.0),
                        ))),
                    onPressed: () {
                      // Open Bidding List Page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BiddingList(
                                  BiddingData: widget.BiddingData)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text("Bidding List",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
