import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Filter.dart';

class BuyerHome extends StatelessWidget {
  const BuyerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage("assets/BuyerImages/headerBackground.jpg"),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  Container(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search property with location',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                      onTap: () {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Move to the Filter Page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilterPage()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(7.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/UI/filterIcon.png",
                                          height: 20,
                                        ),
                                        const Text(
                                          "Filter",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF006E86),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Switch Buy or Rent Modes
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(7.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          print("Buttun Pressed Rent");
                                        },
                                        child: const Text(
                                          "Rent",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF006E86),
                                        ),
                                        onPressed: () {
                                          print("Buttun Pressed Buy");
                                        },
                                        child: const Text(
                                          "Buy",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ]),
                  ),
                  // Trending section

                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Trending',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: "font1",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5F5F5F),
                                ),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontFamily: "font2",
                                  fontSize: 15.0,
                                  color: Color(0xFF006E86),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // First property listing
                              Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Property image
                                      Expanded(
                                        child: Image.asset(
                                            "assets/images/House 01.jpg"),
                                      ),
                                      // Property details
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Property price
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    'Rs 53,000,000',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Image.asset(
                                                  "assets/UI/vrIcon.png",
                                                  height: 20,
                                                ),
                                                Image.asset(
                                                  "assets/UI/mapIcon.png",
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                            // Property location
                                            Text(
                                              'DHA 9 Town, Lahore',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            // Property time posted and favorite icon
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  '4 days ago',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(08.0),
                                                  child: Text(
                                                    '12K',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "assets/UI/viewIcon.png",
                                                    height: 20,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "assets/UI/starIcon.png",
                                                    height: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Second property listing
                            ],
                          ),
                        ),

                        // Property types section
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: AlignmentDirectional.bottomStart,
                          child: const Text(
                            "Find Property",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5F5F5F)),
                          ),
                        ),

                        // Property Type Selection Buttons
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Hostel icon and text
                                InkWell(
                                  onTap: () {
                                    print(" Tap on Hostel");
                                  },
                                  hoverColor: Colors.cyan,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    surfaceTintColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/PropertyLogos/hostelLogo.png",
                                            width: 60,
                                          ),
                                          const Text(
                                            'Hostel',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // House icon and text
                                InkWell(
                                  onTap: () {
                                    print(" Tap on House");
                                  },
                                  hoverColor: Colors.cyan,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    surfaceTintColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/PropertyLogos/houseLogo.png",
                                            height: 60,
                                          ),
                                          const Text(
                                            'House',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Apartment icon and text
                                InkWell(
                                  onTap: () {
                                    print(" Tap on Apartment");
                                  },
                                  hoverColor: Colors.cyan,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    surfaceTintColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/PropertyLogos/apartmentLogo.png",
                                            height: 60,
                                          ),
                                          const Text(
                                            'Apartment',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Room icon and text
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(" Tap on Rooms");
                                      },
                                      hoverColor: Colors.cyan,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        surfaceTintColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/PropertyLogos/roomLogo.png",
                                                height: 60,
                                              ),
                                              const Text(
                                                'Room',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
