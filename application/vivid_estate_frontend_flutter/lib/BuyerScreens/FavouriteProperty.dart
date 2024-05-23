import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class FavouriteProperty extends StatefulWidget {
  FavouriteProperty(
      {super.key,
      required this.PropertyID,
      required this.ImageLocation,
      required this.Price,
      required this.Location,
      required this.TimeAgo,
      required this.Views,
      required this.Likes,
      required this.onCrossPressed});

  // Variables For Our Views
  int PropertyID;
  String ImageLocation;
  String Price;
  String Location;
  int TimeAgo;
  String Views;
  String Likes;
  final Function onCrossPressed;

  @override
  State<FavouriteProperty> createState() => _FavouriteProperty();
}

class _FavouriteProperty extends State<FavouriteProperty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          // Place the Image Of Our Property
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.5) - 40,
            height: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
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
            height: 200,
            child: Column(
              children: [
                // Favourite Property Title Information
                Row(
                  children: [
                    Text((widget.Price).toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 59, 59, 59))),
                    const Spacer(),
                    // Remove Property Button
                    IconButton(
                        onPressed: () {
                          // Remove the Property From Favourite List
                          widget.onCrossPressed(widget.PropertyID);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),

                // Display Other Information

                // Display Location
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.Location,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5F5F5F))),
                ),

                // Display Time
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${widget.TimeAgo} days ago",
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5F5F5F))),
                ),
                // Give Space Between
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
