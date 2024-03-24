import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PropertySearch extends StatefulWidget {
  const PropertySearch({super.key});

  @override
  State<PropertySearch> createState() => _PropertySearch();
}

class _PropertySearch extends State<PropertySearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: InputDecoration(
                  hintText: 'Search property with location',
                  disabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
