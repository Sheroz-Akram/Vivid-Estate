import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Search/SearchResult.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

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

  // Our Buyer Object
  var buyer = Buyer();

  // Store the Filter Data
  dynamic FilterData;

  @override
  void initState() {
    super.initState();
    setState(() {
      FilterData = widget.filterData;
    });
  }

  // Perform the Search Operation based upon the user query
  void searchQuery(BuildContext userContext) async {
    // Perform the Search Operation
    var responseData = await buyer.searchQuery(
        userContext, searchQueryController.text, FilterData);

    // Update our State
    setState(() {
      searchResults = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 130,
              child: Column(
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
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () {
                                    // Button pressed on tap to search directly
                                    if (searchQueryController.text.length >=
                                        3) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchResult(
                                                      filterData: FilterData,
                                                      searchQuery:
                                                          searchQueryController
                                                              .text)));
                                    } else {
                                      displaySnackBar(context,
                                          "Please enter a location to search for properties.");
                                    }
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
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              height: MediaQuery.of(context).size.height - 320,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Search Option is Pressed
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchResult(
                                      filterData: FilterData,
                                      searchQuery: searchResults[index])));
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
                        icon: Container(
                          decoration: BoxDecoration(
                              color: FilterData['PropertyType'] == "Hostel"
                                  ? const Color.fromARGB(255, 177, 177, 177)
                                  : null),
                          child: Image.asset(
                            "assets/PropertyLogos/hostelLogo.png",
                            height: 32,
                          ),
                        ),
                        onPressed: () {
                          // Set Property Type to Hostel
                          setState(() {
                            FilterData['PropertyType'] = "Hostel";
                          });
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
                        icon: Container(
                          decoration: BoxDecoration(
                              color: FilterData['PropertyType'] == "House"
                                  ? const Color.fromARGB(255, 177, 177, 177)
                                  : null),
                          child: Image.asset(
                            "assets/PropertyLogos/houseLogo.png",
                            height: 32,
                          ),
                        ),
                        onPressed: () {
                          // Set Property Type to Apartment
                          setState(() {
                            FilterData['PropertyType'] = "House";
                          });
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
                        icon: Container(
                          decoration: BoxDecoration(
                              color: FilterData['PropertyType'] == "Apartment"
                                  ? const Color.fromARGB(255, 177, 177, 177)
                                  : null),
                          child: Image.asset(
                            "assets/PropertyLogos/apartmentLogo.png",
                            height: 32,
                          ),
                        ),
                        onPressed: () {
                          // Set Property Type to Apartment
                          setState(() {
                            FilterData['PropertyType'] = "Apartment";
                          });
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
                        icon: Container(
                          decoration: BoxDecoration(
                              color: FilterData['PropertyType'] == "Room"
                                  ? const Color.fromARGB(255, 177, 177, 177)
                                  : null),
                          child: Image.asset(
                            "assets/PropertyLogos/roomLogo.png",
                            height: 32,
                          ),
                        ),
                        onPressed: () {
                          // Set Property Type to Room
                          setState(() {
                            FilterData['PropertyType'] = "Room";
                          });
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
