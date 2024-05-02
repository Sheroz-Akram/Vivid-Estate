import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/Authentication/ServerInfo.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Filter.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Search/PropertySearch.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/Search/PropertySearchPreview.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Buyer.dart';
import 'package:vivid_estate_frontend_flutter/Helpers/Help.dart';

// ignore: must_be_immutable
class SearchResult extends StatefulWidget {
  SearchResult(
      {super.key, required this.filterData, required this.searchQuery});

  dynamic filterData;
  dynamic searchQuery;

  @override
  State<SearchResult> createState() => _SearchResult();
}

class _SearchResult extends State<SearchResult> {
  // Our Server Object used to perform search results
  ServerInfo server = ServerInfo();

  // Data for our filters
  var FilterData;
  var searchResults = [];

  // Our Buyer Object
  var buyer = Buyer();

  @override
  void initState() {
    super.initState();
    FilterData = widget.filterData;
    performDetailSearch(context);
  }

  // Request a Detail Search of Perperty
  void performDetailSearch(BuildContext userContext) async {
    // Send a request
    var responseData = await buyer.detailSearchQuery(
        userContext, widget.searchQuery, widget.filterData);

    // Now Update our State
    setState(() {
      searchResults = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                                // Open the Search Screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PropertySearch(
                                              filterData: FilterData,
                                            )));
                              },
                              decoration: InputDecoration(
                                hintText: widget.searchQuery,
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
                                          if (value != null)
                                            {
                                              setState(() {
                                                FilterData = value;
                                              })
                                            }
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  FilterData['ListingType'] ==
                                                          'Rent'
                                                      ? const Color(0xFF006E86)
                                                      : Colors.white),
                                          onPressed: () {
                                            // Select Rent
                                            setState(() {
                                              FilterData['ListingType'] =
                                                  "Rent";
                                            });
                                          },
                                          child: Text(
                                            "Rent",
                                            style: TextStyle(
                                                color:
                                                    FilterData['ListingType'] ==
                                                            'Rent'
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                FilterData['ListingType'] ==
                                                        'Buy'
                                                    ? const Color(0xFF006E86)
                                                    : Colors.white,
                                          ),
                                          onPressed: () {
                                            // Select Buy
                                            setState(() {
                                              FilterData['ListingType'] = "Buy";
                                            });
                                          },
                                          child: Text(
                                            "Buy",
                                            style: TextStyle(
                                                color:
                                                    FilterData['ListingType'] ==
                                                            'Buy'
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),

                        /**
                         * 
                         * Display all the Filters of the Search
                         */
                        Container(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            children: [
                              // Display Floors Selection
                              FilterData['PropertyType'] != "None"
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Property Type:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              FilterData['PropertyType'] ==
                                                      "None"
                                                  ? "0"
                                                  : FilterData['PropertyType'],
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Clear the Size Selection Of Filter
                                                setState(() {
                                                  FilterData['PropertyType'] =
                                                      "None";
                                                });
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text(''),

                              // Display Price Filter
                              FilterData['Price']['Lower'] != '' ||
                                      FilterData['Price']['Upper'] != ''
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Price:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              FilterData['Price']['Lower'] == ''
                                                  ? "0"
                                                  : formatNumber(int.parse(
                                                      FilterData['Price']
                                                          ['Lower'])),
                                            ),
                                            const Text(" to "),
                                            Text(
                                              FilterData['Price']['Upper'] == ''
                                                  ? "∞"
                                                  : formatNumber(int.parse(
                                                      FilterData['Price']
                                                          ['Upper'])),
                                            ),
                                            const SizedBox(width: 3),
                                            InkWell(
                                              onTap: () {
                                                // Clear the price Selection
                                                setState(() {
                                                  FilterData['Price']['Upper'] =
                                                      '';
                                                  FilterData['Price']['Lower'] =
                                                      '';
                                                });
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text(''),

                              // Display Size Filter
                              FilterData['Size']['Lower'] != '' ||
                                      FilterData['Size']['Upper'] != ''
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Size:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              FilterData['Size']['Lower'] == ''
                                                  ? "0"
                                                  : formatNumber(int.parse(
                                                      FilterData['Size']
                                                          ['Lower'])),
                                            ),
                                            const Text(" to "),
                                            Text(
                                              FilterData['Size']['Upper'] == ''
                                                  ? "∞"
                                                  : formatNumber(int.parse(
                                                      FilterData['Size']
                                                          ['Upper'])),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Clear the Size Selection Of Filter
                                                setState(() {
                                                  FilterData['Size']['Upper'] =
                                                      '';
                                                  FilterData['Size']['Lower'] =
                                                      '';
                                                });
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text(''),

                              // Display Beds Selection
                              FilterData['NoBeds'] != ''
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Beds:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              FilterData['NoBeds'] == ''
                                                  ? "0"
                                                  : formatNumber(int.parse(
                                                      FilterData['NoBeds'])),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Clear the Size Selection Of Filter
                                                setState(() {
                                                  FilterData['NoBeds'] = '';
                                                });
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text(''),

                              // Display Floors Selection
                              FilterData['NoFloors'] != ''
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Floors:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              FilterData['NoFloors'] == ''
                                                  ? "0"
                                                  : formatNumber(int.parse(
                                                      FilterData['NoFloors'])),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Clear the Size Selection Of Filter
                                                setState(() {
                                                  FilterData['NoFloors'] = '';
                                                });
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),

              /**
               * Display the Search Results
               */
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchResults.isNotEmpty
                        ? Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Search Results:",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF8D8D8D)),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return index == searchResults.length
                                          ? SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                            )
                                          : PropertySearchPreview(
                                              propertySimpleInformation: {
                                                  "PropertyID":
                                                      searchResults[index]
                                                          ["PropertyID"],
                                                  "PropertyImageAddress":
                                                      "${server.host}/static/${searchResults[index]['Picture']}",
                                                  "Price": searchResults[index]
                                                      ['Price'],
                                                  "Location":
                                                      searchResults[index]
                                                          ['Location'],
                                                  "Type": searchResults[index]
                                                      ['Type']
                                                });
                                    },
                                    itemCount: searchResults.length + 1,
                                  )),
                            ],
                          )
                        : const Center(
                            child: Text("No Results Found",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF8D8D8D))),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
