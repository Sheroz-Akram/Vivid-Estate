import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Filter.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Search/PropertySearch.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

class BuyerHome extends StatelessWidget {
  BuyerHome({super.key});

  // Filter Data of the User
  Map<String, Object> FilterData = {
    "PropertyType": 'None',
    "Price": {"Lower": '', "Upper": ''},
    "Size": {"Lower": '', "Upper": ''},
    "NoBeds": '',
    "NoFloors": ''
  };

  // Static Data of Reviews
  final reviews = [
    {
      "ProfilePic": "assets/house.jpg",
      "Name": "Sheroz Akram",
      "Title": "A home search lifesaver!",
      "Date": "12/02/2024",
      "Rating": 4.5,
      "Text":
          "This app is amazing. The filters are so detailed, and the map view lets me pinpoint exactly the neighborhoods I want. I found my dream apartment through this app, and I couldn't be happier."
    },
    {
      "ProfilePic": "assets/house2.jpg",
      "Name": "Ali Haider",
      "Title": "My new real estate sidekick",
      "Date": "10/01/2024",
      "Rating": 3.5,
      "Text":
          "Love the clean interface and how easy it is to save listings. The mortgage calculator is a really helpful bonus feature, too. Makes the whole house hunting process way less overwhelming."
    },
    {
      "ProfilePic": "assets/house.jpg",
      "Name": "Faizan Hassan",
      "Title": "So much better than other sites",
      "Date": "10/11/2023",
      "Rating": 4.0,
      "Text":
          "The listings on this app seem more up-to-date than the big name real estate websites. The instant notifications when something matches my criteria are fantastic."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
            children: [
              Container(
                  child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Vivid Estate",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0XFF006E86)),
                ),
              )),
              Container(
                  child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "You Path to Real Residence ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0XFF006E86)),
                ),
              )),
            ],
          ),
          leading: Image.asset(
            "assets/logo.png",
            width: 10,
            height: 20,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Page Header
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/BuyerImages/headerBackground.png"),
                            fit: BoxFit.fill)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PropertySearch()));
                            },
                            decoration: InputDecoration(
                              hintText: 'Search property with location',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
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
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Move to the Filter Page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilterPage(
                                                filterData: FilterData,
                                              ))).then((value) => {
                                        // Value Returned from the Filter Page
                                        FilterData = value
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
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
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(2.0),
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

                        // Houses Carousal
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(10),
                          child: CarouselSlider(
                            items: [
                              // First Item
                              addPreview(
                                  "assets/house.jpg",
                                  12234324,
                                  "Harbanspura, Lahore",
                                  MediaQuery.of(context).size.width * 0.80),

                              addPreview(
                                  "assets/house2.jpg",
                                  54545432,
                                  "Johar Town, Lahore",
                                  MediaQuery.of(context).size.width * 0.80)
                            ],
                            options: CarouselOptions(
                              height: 280,
                              autoPlay: true,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              viewportFraction: 0.8,
                            ),
                          ),
                        ),

                        // Property types section
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: AlignmentDirectional.bottomStart,
                          child: const Text(
                            "Explore Properties",
                            style: TextStyle(
                                fontSize: 24,
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
                                            width: 40,
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
                                            height: 40,
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
                                            height: 40,
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
                                                height: 40,
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
            ),

            // Reviews Section
            Container(
              padding: const EdgeInsets.all(10),
              alignment: AlignmentDirectional.bottomStart,
              child: const Text(
                "Customer Reviews",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5F5F5F)),
              ),
            ),

            // Review Carousal
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                child: CarouselSlider.builder(
                  itemCount: reviews.length,
                  itemBuilder: (BuildContext userContext, int itemIndex,
                          int pageViewIndex) =>
                      Container(
                    child: Center(
                      child: generalReview(
                          reviews[itemIndex]['ProfilePic'],
                          reviews[itemIndex]['Name'],
                          reviews[itemIndex]['Title'],
                          reviews[itemIndex]['Rating'],
                          reviews[itemIndex]['Date'],
                          reviews[itemIndex]['Text'],
                          MediaQuery.of(context).size.width * 0.90),
                    ),
                  ),
                  options: CarouselOptions(
                    height: 230,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
