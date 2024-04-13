import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class NewPropertyAd extends StatefulWidget {
  const NewPropertyAd({super.key});

  @override
  State<NewPropertyAd> createState() => _NewPropertyAdState();
}

class _NewPropertyAdState extends State<NewPropertyAd> {
  // Store Data
  var selectedPropertyType = 'None';
  var listingType = 'Sell';
  var propertyLocationData = {
    "isSet": "no",
    "latitude": 0.0,
    "longitude": 0.0,
    "address": "none"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              "Create New Property",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF006E86),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*
                    
                    Top Right Button to close the new property creation menu

                    */
                    Container(
                      child: CloseButton(
                        color: const Color(0XFF006E86),
                        onPressed: () {
                          // Move to the previous screen
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Fill in the information"
                      " below to add new property to your listing",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: const Text(
                    "Property Type",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF8D8D8D),
                    ),
                  ),
                ),

                /*
                
                Select Property type of the advertisement
                
                */
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, top: 10, bottom: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['House', 'Apartment', 'Hostel', 'Room']
                        .map((type) => ChoiceChip(
                            label: Text(type),
                            selected: selectedPropertyType == type,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedPropertyType = type;
                              });
                            },
                            selectedColor: const Color(0xFF006E86),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: selectedPropertyType == type
                                  ? Colors.white
                                  : Colors.black, // Adjust 'black' if needed
                            )))
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const Text(
                                "Listing Type",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF8D8D8D),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              children: [
                                Container(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: listingType == 'Sell'
                                            ? const Color(0xFF006E86)
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        // Change the listing type
                                        setState(() {
                                          listingType = 'Sell';
                                        });
                                      },
                                      child: Text(
                                        "Sell",
                                        style: TextStyle(
                                            color: listingType == 'Sell'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: listingType == 'Rent'
                                            ? const Color(0xFF006E86)
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        // Change the listing type
                                        setState(() {
                                          listingType = 'Rent';
                                        });
                                      },
                                      child: Text("Rent",
                                          style: TextStyle(
                                              color: listingType == 'Rent'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: const Text(
                                  "Select Location",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF8D8D8D)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpenStreetMapSearchAndPick(
                                                locationPinText:
                                                    "Property Location",
                                                locationPinTextStyle:
                                                    const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                locationPinIconColor:
                                                    Colors.red,
                                                locationPinIcon:
                                                    Icons.location_on,
                                                buttonColor:
                                                    const Color(0xFF006E86),
                                                buttonText:
                                                    'Set Current Location',
                                                onPicked: (pickedData) {
                                                  // Move Back to Previous Screen
                                                  Navigator.pop(context);

                                                  print(pickedData.addressName);

                                                  setState(() {
                                                    // Set the Longitude and Langitude
                                                    propertyLocationData[
                                                        'isSet'] = 'yes';
                                                    propertyLocationData[
                                                            'latitude'] =
                                                        pickedData
                                                            .latLong.latitude;
                                                    propertyLocationData[
                                                            'longitude'] =
                                                        pickedData
                                                            .latLong.longitude;
                                                    propertyLocationData[
                                                            'address'] =
                                                        pickedData.addressName;
                                                  });
                                                })));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: propertyLocationData['isSet'] ==
                                                'yes'
                                            ? SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: SizedBox(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4) -
                                                      30,
                                                  child: Text(
                                                      textAlign:
                                                          TextAlign.justify,
                                                      '${propertyLocationData['address']}'),
                                                ),
                                              )
                                            : const Text("Open Maps")),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      "Property Info",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF8D8D8D)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              listingType == 'Rent' ? "Price/Month" : "Price",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0XFF5093A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Size(in meter)",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0XFF5093A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      "Living Space",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF8D8D8D)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "No of Beds",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0XFF5093A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownMenu(
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: "1", label: "1"),
                              DropdownMenuEntry(value: "1", label: "2"),
                              DropdownMenuEntry(value: "2", label: "3"),
                              DropdownMenuEntry(value: "3", label: "4"),
                              DropdownMenuEntry(value: "5", label: "5"),
                              DropdownMenuEntry(value: "6", label: "6"),
                              DropdownMenuEntry(value: "7", label: "7"),
                              DropdownMenuEntry(value: "8", label: "8"),
                              DropdownMenuEntry(value: "9", label: "9"),
                              DropdownMenuEntry(value: "10", label: "10"),
                            ],
                            width: MediaQuery.of(context).size.width * 0.4,
                            hintText: "Select  Beds",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "No of Floors",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0XFF5093A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownMenu(
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: "1", label: "1"),
                              DropdownMenuEntry(value: "1", label: "2"),
                              DropdownMenuEntry(value: "2", label: "3"),
                              DropdownMenuEntry(value: "3", label: "4"),
                            ],
                            width: MediaQuery.of(context).size.width * 0.4,
                            hintText: "Select  Floors",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Ad Pictures",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF8D8D8D)),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 60,
                    child: InkWell(
                      child:
                          ListView(scrollDirection: Axis.horizontal, children: [
                        Image.asset("assets/images/g.png"),
                        Image.asset("assets/images/g.png"),
                      ]),
                      onTap: () {
                        print("Select images");
                      },
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Row(
                        children: [
                          Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: InkWell(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 60,
                                      width: 80,
                                      child: Image.asset(
                                          "assets/images/Image 17@1x (2).png")),
                                  const Text(
                                    "2D layout",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("2DLayout");
                              },
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: InkWell(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 60,
                                      width: 80,
                                      child: Image.asset(
                                          "assets/images/Image 17@1x (3).png")),
                                  const Text(
                                    "360 View",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("360 View");
                              },
                            ),
                          ),
                        ],
                      )),
                      Container(
                        height: 40,
                        width: 100,
                        margin: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 40,
                              shadowColor: Colors.black,
                              backgroundColor: const Color(0XFF006E86),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 3)),
                            ),
                            onPressed: () {
                              print("Done ");
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
