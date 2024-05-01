import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';

// ignore: must_be_immutable
class PropertySearch extends StatefulWidget {
  PropertySearch({super.key, required this.filterData});

  dynamic filterData;

  @override
  State<PropertySearch> createState() => _PropertySearch();
}

class _PropertySearch extends State<PropertySearch> {
  // Our Server Object used to perform search results
  ServerInfo server = ServerInfo();

  // Our Text controller
  var searchQueryController = TextEditingController();
  var searchResults = [];

  // Perform the Search Operation based upon the user query
  void searchQuery(BuildContext userContext) {
    // Check if user has enter any data or not
    if (searchQueryController.text.length < 3) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    // Data to Send to the Server
    var searchQueryData = {
      "Query": searchQueryController.text,
      "Filter": jsonEncode(widget.filterData)
    };

    // Send Our POST Requst to the Server
    server.sendPostRequest(userContext, "search_property", searchQueryData,
        (result) {
      if (result['status'] == "success") {
        setState(() {
          searchResults = [];
        });
        for (var element in result['message']['SearchItems']) {
          setState(() {
            searchResults.add(element as String);
          });
        }
      }
      ScaffoldMessenger.of(userContext)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0XFF006E86))),
                const Text(
                  "Property Search",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Color(0XFF006E86)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: searchQueryController,
                  onChanged: (value) {
                    // Update the Search Result When the Value Got Changed
                    searchQuery(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search property with location',
                    disabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              // Button pressed on tap to search directly
                              print(" Tap on Search");
                            },
                            child: Image.asset(
                              "assets/UI/searchButton.png",
                              height: 40,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              height: MediaQuery.of(context).size.height - 212,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Search Option is Pressed
                          print("Pressed at $index");
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 5, right: 5),
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 238, 238, 238)),
                          child: Text(
                            searchResults[index],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
                itemCount: searchResults.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            height: 100,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/PropertyLogos/hostelLogo.png",
                          height: 32,
                        ),
                        onPressed: () {
                          // Navigate to home or perform other action
                        },
                      ),
                      const Text(
                        "Hostels",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/PropertyLogos/houseLogo.png",
                          height: 32,
                        ),
                        onPressed: () {
                          // Navigate to home or perform other action
                        },
                      ),
                      const Text(
                        "House",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/PropertyLogos/apartmentLogo.png",
                          height: 32,
                        ),
                        onPressed: () {
                          // Navigate to home or perform other action
                        },
                      ),
                      const Text(
                        "Apartment",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/PropertyLogos/roomLogo.png",
                          height: 32,
                        ),
                        onPressed: () {
                          // Navigate to home or perform other action
                        },
                      ),
                      const Text(
                        "Rooms",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
