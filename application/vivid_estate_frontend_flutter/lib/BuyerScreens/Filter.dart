import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class FilterPage extends StatefulWidget {
  FilterPage({super.key, required this.filterData});
  dynamic filterData;
  @override
  State<FilterPage> createState() => _FilterPage();
}

class _FilterPage extends State<FilterPage> {
  // Filter Information
  var selectedPropertyType = 'None';
  var priceLower = TextEditingController();
  var priceUpper = TextEditingController();
  var sizeUpper = TextEditingController();
  var sizeLower = TextEditingController();
  var noFloorsDropDown = TextEditingController();
  var noBedsDropDown = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set the already set filters in the Filters Page
    setState(() {
      selectedPropertyType = widget.filterData['PropertyType'];
    });
    priceLower.text = widget.filterData['Price']['Lower'];
    priceUpper.text = widget.filterData['Price']['Upper'];
    sizeUpper.text = widget.filterData['Size']['Upper'];
    sizeLower.text = widget.filterData['Size']['Lower'];
    noFloorsDropDown.text = widget.filterData['NoBeds'];
    noBedsDropDown.text = widget.filterData['NoFloors'];
  }

  // Clear All the Settings of the filter
  void clearFilterSettings() {
    // Reset all the data
    noBedsDropDown.text = '';
    noFloorsDropDown.text = '';
    priceLower.text = '';
    priceUpper.text = '';
    sizeLower.text = '';
    sizeUpper.text = '';
    setState(() {
      selectedPropertyType = 'None';
    });
  }

  // Apply the Filters and Send Data to the main Screen
  void applyFilters(BuildContext userContext) {
    // Data Need to be Send to Previous Screen
    var FilterData = {
      "PropertyType": selectedPropertyType,
      "Price": {"Lower": priceLower.text, "Upper": priceUpper.text},
      "Size": {"Lower": sizeLower.text, "Upper": sizeUpper.text},
      "NoBeds": noBedsDropDown.text,
      "NoFloors": noFloorsDropDown.text
    };

    // Move to Previous Screen
    Navigator.of(userContext).pop(FilterData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // Move to previous Screen
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                    color: const Color(0xFF006E86),
                  ),
                  InkWell(
                      onTap: () {
                        // Reset the filter
                        clearFilterSettings();
                      },
                      child: const Text(
                        "Clear all",
                        style: TextStyle(
                          color: Color(0xFF006E86),
                          fontFamily: "font1",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Filters List',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "font1",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 25, left: 10, top: 10),
                child: Text(
                  'Property Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "font1",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
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
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),

              /**
               * Select Price of the Property in Range
               */
              const Text(
                'Price Range',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("From:"),
                                        ],
                                      ),
                                      TextField(
                                          controller: priceLower,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Lowest",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.sizeOf(context).width *
                                          0.20) -
                                      40,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(children: [
                                    const Row(
                                      children: [
                                        Text("To:"),
                                      ],
                                    ),
                                    TextField(
                                        controller: priceUpper,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Highest",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ]),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),

              /**
               * Select the Size of the Property in Range
               */
              const Text(
                'Property Size (in meters)',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("From:"),
                                        ],
                                      ),
                                      TextField(
                                          controller: sizeLower,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Lowest",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.sizeOf(context).width * 0.20) -
                                        40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  child: Column(children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("To:"),
                                      ],
                                    ),
                                    TextField(
                                        controller: sizeUpper,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Highest",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ]),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Living Space',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "font1",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            children: [
                              /**
                         * Input number of beds in the property
                         */
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "No of Beds",
                                ),
                              ),
                              DropdownMenu(
                                controller: noBedsDropDown,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
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
                                width: MediaQuery.of(context).size.width * 0.40,
                                hintText: "Select  Beds",
                              ),
                            ],
                          ),
                        ),

                        /**
                                     * 
                                     * Input Number of floors of the property
                                     * 
                                     */
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "No of Floors",
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: DropdownMenu(
                                  controller: noFloorsDropDown,
                                  inputDecorationTheme: InputDecorationTheme(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(value: "1", label: "1"),
                                    DropdownMenuEntry(value: "1", label: "2"),
                                    DropdownMenuEntry(value: "2", label: "3"),
                                    DropdownMenuEntry(value: "3", label: "4"),
                                  ],
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  hintText: "Select  Floors",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      // Apply filters
                      applyFilters(context);
                    },
                    style: ButtonStyle(
                      shadowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 107, 107, 107)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFF006E86)),
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(width: 4, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
